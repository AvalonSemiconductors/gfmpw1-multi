`default_nettype none
`timescale 1ns/100ps

module tb(
	input WEb,
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

wire [8:0] io_in = {WEb, data};
wire [24:0] io_out;

wire DAC_clk = io_out[22];
wire DAC_dat = io_out[24];
wire DAC_le = io_out[23];

wrapped_sn76489 wrapped_sn76489(
	.wb_clk_i(clk),
	.rst_n(rst_n),
	.io_in(io_in),
	.io_out(io_out),
	.custom_settings(2'b00)
);

DAC7611 DAC7611(
	.clk(DAC_clk),
	.dat(DAC_dat),
	.leb(DAC_le),
	.rst_b(rst_n)
);

endmodule
