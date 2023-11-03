`default_nettype none
`timescale 1ns/100ps

module tb(
	input WEb,
	input [5:0] address,
	input [7:0] data,

	input clk,
	input rst_n
);

`ifdef TRACE_ON
	initial begin
		$dumpfile("tb.vcd");
		$dumpvars(0, tb);
		#1;
	end
`endif

wire [32:0] io_in = {16'h0000, WEb, 1'b1, WEb, address, data};
wire [20:0] io_out;
wire io_oeb;

wire DAC_clk = io_out[19];
wire DAC_dat_1 = io_out[17];
wire DAC_le = io_out[18];
wire DAC_dat_2 = io_out[20];

wrapped_sid wrapped_sid(
	.wb_clk_i(clk),
	.rst_n(rst_n),
	.io_in(io_in),
	.io_out(io_out),
	.io_oeb(io_oeb)
);

DAC7611 DAC7611(
	.clk(DAC_clk),
	.dat1(DAC_dat_1),
	.dat2(DAC_dat_2),
	.leb(DAC_le),
	.rst_b(rst_n)
);

endmodule
