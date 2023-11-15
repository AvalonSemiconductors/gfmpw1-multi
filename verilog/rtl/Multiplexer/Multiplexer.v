`default_nettype none
module multiplexer(
`ifdef USE_POWER_PINS
	inout vdd,
	inout vss,
`endif
	input [37:0] io_in,
	output [37:0] io_out,
	output [37:0] io_oeb,
	
	input wb_clk_i,
	input wb_rst_i,
	
	input [31:0] wbs_adr_i,
	input [31:0] wbs_dat_i,
	output [31:0] wbs_dat_o,
	input wbs_we_i,
	input wbs_cyc_i,
	input wbs_stb_i,
	output wbs_ack_o,
	
	output rst_blinker,
	input [2:0] blinker_do,

	output rst_sid,
	input [20:0] sid_do,
	input sid_oeb,

	output rst_sn76489,
	input [27:0] sn76489_do,
	
	output rst_qcpu,
	input [32:0] qcpu_do,
	input [32:0] qcpu_oeb,
	input [5:0] qcpu_sram_addr,
	input [7:0] qcpu_sram_in,
	output [7:0] qcpu_sram_out,
	input qcpu_sram_gwe,
	
	output rst_mc14500,
	input [30:0] mc14500_do,
	input [5:0] mc14500_sram_addr,
	input [7:0] mc14500_sram_in,
	input mc14500_sram_gwe,
	
	output rst_ay8913,
	input [27:0] ay8913_do,
	
	output rst_hellorld,
	input hellorld_do,
	
	output rst_tbb1143,
	input [4:0] tbb1143_do,

	output reg [31:0] custom_settings,
	
	output [2:0] irq
);
assign irq = 3'b000;

reg [4:0] design_select;

reg wb_ready;
reg [31:0] wbs_o_buff;
reg [31:0] wb_counter;
reg wb_feedback_delay;
reg wb_override_act;
reg wb_rst_override;
assign wbs_dat_o = wbs_o_buff;
assign wbs_ack_o = wb_ready;

wire wb_valid = wbs_cyc_i && wbs_stb_i;
wire design_rst_base = wb_override_act ? wb_rst_override : io_in[0];
reg [32:0] design_out;
reg [32:0] design_oeb;

assign io_out = {design_out, 5'h00};
assign io_oeb = {design_oeb, 5'h1F};

wire design_needs_sram = design_select == 0 || design_select == 4 || design_select == 5;
wire sram_cen = ~design_needs_sram || wb_rst_i;

reg wb_sram_we;
wire [5:0] sram_A = design_select == 4 ? qcpu_sram_addr : (design_select == 5 ? mc14500_sram_addr : wbs_adr_i[7:2]);
wire [7:0] sram_D = design_select == 4 ? qcpu_sram_in : (design_select == 5 ? mc14500_sram_in : wbs_dat_i[7:0]);
wire [7:0] sram_wen = 8'h00;
wire sram_gwen = design_select == 4 ? ~qcpu_sram_gwe : (design_select == 5 ? ~mc14500_sram_gwe : ~wb_sram_we);
wire [7:0] sram_Q;
assign qcpu_sram_out = sram_Q;

always @(posedge wb_clk_i) begin
	if(wb_rst_i) begin
		wb_override_act <= 0;
		design_select <= 0;
		wb_ready <= 0;
		wb_counter <= 0;
		wbs_o_buff <= 0;
		wb_sram_we <= 0;
		wb_feedback_delay <= 0;
		wb_rst_override <= 1'b1;
		custom_settings <= 1'b0;
	end else begin
		wb_counter <= wb_counter + 1;
		if(wb_valid && !wb_feedback_delay) begin
			if(wbs_adr_i[23]) begin
				if(wbs_we_i) begin
					wb_override_act <= wbs_dat_i[0];
					wb_rst_override <= wbs_dat_i[1];
					design_select <= wbs_dat_i[6:2];
				end
				wbs_o_buff <= {24'h000000, 1'b1, design_select, wb_rst_override, wb_override_act};
			end else if(wbs_adr_i[22]) begin
				if(wbs_we_i) begin
					wb_counter <= wbs_dat_i;
				end
				wbs_o_buff <= wb_counter;
			end else if(wbs_adr_i[21]) begin
				if(wbs_we_i) begin
					custom_settings <= wbs_dat_i;
				end
				wbs_o_buff <= custom_settings;
			end else if(wbs_adr_i[20]) begin
				wb_sram_we <= wbs_we_i && !wb_ready;
				wbs_o_buff <= {24'h000000, sram_Q};
			end else begin
				wbs_o_buff <= 32'hFFFFFFFF;
			end
		end
		wb_feedback_delay <= wb_valid;
		wb_ready <= wb_feedback_delay;
		if(wb_ready) begin
			wb_sram_we <= 1'b0;
		end
	end
end

assign rst_blinker = design_rst_base && design_select == 1;
assign rst_sid = design_rst_base && design_select == 2;
assign rst_sn76489 = design_rst_base && design_select == 3;
assign rst_qcpu = design_rst_base && design_select == 4;
assign rst_mc14500 = design_rst_base && design_select == 5;
assign rst_ay8913 = design_rst_base && design_select == 6;
assign rst_hellorld = design_rst_base && design_select == 7;
assign rst_tbb1143 = design_rst_base && design_select == 8;

always @(*) begin
	case(design_select)
		0: begin
			design_out = 33'h000000000;
			design_oeb = 33'h1FFFFFFFF;
		end
		1: begin
			design_out = {21'h000000, blinker_do, blinker_do, blinker_do, blinker_do};
			design_oeb = 33'h1FFFFF000;
		end
		2: begin
			design_out = {12'h000, sid_do};
			design_oeb = {11'h7FF, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 5'b11111, sid_oeb, sid_oeb, sid_oeb, sid_oeb, sid_oeb, sid_oeb, sid_oeb, sid_oeb};
		end
		3: begin
			design_out = {5'h00, sn76489_do};
			design_oeb = {5'h00, 8'h00, 3'b000, 4'hF, custom_settings[2] ? 5'b00000 : 5'b11111, 8'hFF};
		end
		4: begin
			design_out = qcpu_do;
			design_oeb = qcpu_oeb;
		end
		5: begin
			design_out = {1'b0, 1'b0, mc14500_do};
			design_oeb = {1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 17'h00000, 8'hFF};
		end
		6: begin
			design_out = {5'h00, ay8913_do};
			design_oeb = {5'h00, 8'h00, 3'b000, 5'h1F, custom_settings[2] ? 4'b0000 : 4'b1111, 8'hFF};
		end
		7: begin
			design_out = {21'h000000, {12{hellorld_do}}};
			design_oeb = 33'h1FFFFF000;
		end
		8: begin
			design_out = {11'h000, tbb1143_do[4:3], tbb1143_do[1], tbb1143_do[0], tbb1143_do[2], 3'b000, 6'h00, 8'h00};
			design_oeb = {11'h7FF, 2'b00, 3'b000, 3'b111, 6'h3F, 8'hFF};
		end

		default: begin
			design_out = 33'b100000000010001010011000101001100; //'RTFM' in base64
			design_oeb = 33'h000000000;
		end
	endcase
end

dffram dffram(
	.CLK(wb_clk_i),
	.CEN(sram_cen),
	.GWEN(sram_gwen),
	.WEN(sram_wen),
	.A(sram_A),
	.D(sram_D),
	.Q(sram_Q)
);

endmodule
