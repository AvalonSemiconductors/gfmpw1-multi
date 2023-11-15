`default_nettype none
module tholin_avalonsemi_tbb1143(
`ifdef USE_POWER_PINS
	inout vdd,
	inout vss,
`endif
	input clk,
	input rst_n,
	input [5:0] io_in,
	output [4:0] io_out
);
	wire A0 = io_in[0];
	wire WR = io_in[1];
	wire s_D0 = io_in[2];
	wire s_D1 = io_in[3];
	wire s_D2 = io_in[4];
	wire s_D3 = io_in[5];
	wire rst = !rst_n;
	
	wire [5:0] s_SOUT;
	
	wire LED0;
	assign io_out[3] = LED0;
	wire LED1;
	assign io_out[4] = LED1;
	
	reg [7:0] slow_clock;
	
	always @(posedge clk) begin
		if(rst) begin
			slow_clock <= 0;
		end else begin
			slow_clock <= slow_clock + 1;
		end
	end
	
	spi_dac_i_2 spi_dac_i_2(
		.sample_in({s_SOUT, 6'b000011}),
		.clk(clk),
		.rst(rst),
		.spi_le(io_out[0]),
		.spi_clk(io_out[1]),
		.spi_dat(io_out[2]),
		.sample_ready(1'b1)
	);

	main_tbb1143   CIRCUIT_2223 (.A0(A0),
							.CLK(slow_clock[7]),
							.D0(s_D0),
							.D1(s_D1),
							.D2(s_D2),
							.D3(s_D3),
							.FCLK(clk),
							.RST(rst),
							.WR(WR),
							.S0(s_SOUT[0]),
							.S1(s_SOUT[1]),
							.S2(s_SOUT[2]),
							.S3(s_SOUT[3]),
							.S4(s_SOUT[4]),
							.S5(s_SOUT[5]),
							.LED0(LED0),
							.LED1(LED1)
							);
endmodule
