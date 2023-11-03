`default_nettype none

module wrapped_sid(
`ifdef USE_POWER_PINS
	inout vdd,
	inout vss,
`endif
	input wb_clk_i,
	input rst_n,
	input [32:0] io_in,
	output [20:0] io_out,
	output io_oeb
);

wire oe;
assign io_oeb = ~oe;
wire [7:0] bus_out;
wire DAC_clk;
wire DAC_dat_1;
wire DAC_dat_2;
wire DAC_le;

assign io_out = {DAC_dat_2, DAC_clk, DAC_le, DAC_dat_1, 1'b0, 1'b0, 1'b0, 6'b000000, bus_out};

sid_top sid_top(
	.clk(wb_clk_i),
	.rst_n(rst_n),
	.WEb(io_in[14]),
	.OEb(io_in[15]),
	.CEb(io_in[16]),
	.reg_addr(io_in[13:8]),
	.DAC_clk(DAC_clk),
	.DAC_dat_1(DAC_dat_1),
	.DAC_dat_2(DAC_dat_2),
	.DAC_le(DAC_le),
	.oe(oe),
	.bus_in(io_in[7:0]),
	.bus_out(bus_out)
);

endmodule
