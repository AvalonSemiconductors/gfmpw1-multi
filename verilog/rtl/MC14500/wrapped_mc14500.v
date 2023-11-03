`default_nettype none

module wrapped_mc14500(
`ifdef USE_POWER_PINS
	inout vdd,
	inout vss,
`endif
	input clk_i,
	input rst_n,
	input [7:0] io_in,
	input SDI,
	output [30:0] io_out,
	output [5:0] sram_addr,
	output [7:0] sram_in,
	input [7:0] sram_out,
	output sram_gwe,
	input custom_setting
);

wire X1;
wire RR;
wire WRITE;
wire DATA_OUT;
wire JMP;
wire RTN;
wire FLAG_O;
wire FLAG_F;

reg out_1;
reg out_2;
reg clk_div;
reg [16:0] dest;
reg [16:0] PC;
assign io_out[7:0] = 8'h00;
assign io_out[24:8] = PC;
assign io_out[25] = FLAG_O;
assign io_out[26] = RR;
assign io_out[27] = SCLK;
assign io_out[28] = SDO;
assign io_out[29] = out_1;
assign io_out[30] = out_2;
wire [3:0] addr = io_in[7:4];

reg [7:0] mar;
wire [7:0] mar_adj = {mar[0], mar[1], mar[2], mar[3], mar[4], mar[5], mar[6], mar[7]};
reg [7:0] dob;
reg [7:0] dia;
reg [7:0] dib;
reg [1:0] rst_latency;
reg scratch [7:0];
assign sram_addr = mar_adj[5:0];
assign sram_in = dob;
assign sram_gwe = !clk_div && FLAG_F;
wire SCLK = scratch[6];
wire SDO = scratch[7];

`ifdef SIM
wire [7:0] scratch_mem = {scratch[7], scratch[6], scratch[5], scratch[4], scratch[3], scratch[2], scratch[1], scratch[0]};

wire [7:0] dob_adj = {dob[0], dob[1], dob[2], dob[3], dob[4], dob[5], dob[6], dob[7]};
`endif

wire DATA_IN = addr == 0 ? 1'b1 : (addr[3] ? scratch[addr[2:0]] : (
	(addr == 3 && dia[7]) || (addr == 4 && dib[7]) || (addr == 7 && SDI)
));

always @(posedge clk_i) begin
	if(!rst_n) begin
		clk_div <= 1'b0;
		dest <= 17'h00000;
		PC <= 17'h00000;
		out_1 <= 1'b1;
		out_2 <= 1'b1;
		mar <= 8'h00;
		dob <= 8'h00;
		dia <= 8'h00;
		dib <= 8'h00;
		scratch[0] <= 1'b0;
		scratch[1] <= 1'b0;
		scratch[2] <= 1'b0;
		scratch[3] <= 1'b0;
		scratch[4] <= 1'b0;
		scratch[5] <= 1'b0;
		scratch[6] <= 1'b0;
		scratch[7] <= 1'b0;
		rst_latency <= 2'b11;
	end else begin
		if(custom_setting) begin
			dest[16] <= 1'b0;
			PC[16] <= 1'b0;
		end
		clk_div <= !clk_div;
		if(rst_latency) rst_latency <= rst_latency - 1;
		if(clk_div && !rst_latency) begin
			if(JMP) PC <= dest;
			else PC <= PC + 1;
			if(RTN) mar <= 8'h00;
			else if(WRITE && addr == 1) mar <= {mar[6:0], DATA_OUT};
			if(WRITE && addr == 0) dest <= {dest[15:0], DATA_OUT};
			if(WRITE && addr == 2) dob <= {dob[6:0], DATA_OUT};
			if(FLAG_O && addr == 1) dia <= sram_out;
			if(FLAG_O && addr == 2) dib <= sram_out;
			if(WRITE && addr[3]) scratch[addr[2:0]] <= DATA_OUT;
			if(WRITE && addr == 5) out_1 <= DATA_OUT;
			if(WRITE && addr == 6) out_2 <= DATA_OUT;
			if(addr == 3) dia <= {dia[6:0], 1'b0};
			if(addr == 4) dib <= {dib[6:0], 1'b0};
		end
	end
end

mc14500 mc14500(
	.X2(clk_div),
	.RST(~rst_n || rst_latency),
	.I(io_in[3:0]),
	.X1(X1),
	.DATA_IN(DATA_IN),
	.DATA_OUT(DATA_OUT),
	.WRITE(WRITE),
	.RR(RR),
	.JMP(JMP),
	.RTN(RTN),
	.FLAG_O(FLAG_O),
	.FLAG_F(FLAG_F)
);

endmodule
