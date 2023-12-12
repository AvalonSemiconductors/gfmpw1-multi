module ue1(
`ifdef USE_POWER_PINS
	inout vdd,
	inout vss,
`endif
	input clk,
	input rst_n,
	
	input [4:0] io_in,
	output io_oeb,
	output [9:0] io_out
);

wire data_in = io_in[0];
wire RR;
wire WRITE;
assign io_out[0] = RR;
assign io_oeb = WRITE ? 1'b0 : 1'b1;
assign io_out[1] = WRITE;

main_ue1 main(
	.CLK(clk & rst_n),
	.DATA(data_in & rst_n),
	.I0(io_in[1] & rst_n),
	.I1(io_in[2] & rst_n),
	.I2(io_in[3] & rst_n),
	.I3(io_in[4] & rst_n),
	.RST(!rst_n),
	.CAR(io_out[2]),
	.IEN(io_out[3]),
	.JMP(io_out[4]),
	.NOPF(io_out[5]),
	.NOPO(io_out[6]),
	.OEN(io_out[7]),
	.RR(RR),
	.RTN(io_out[8]),
	.SKIP(io_out[9]),
	.WRITE(WRITE)
);

endmodule
