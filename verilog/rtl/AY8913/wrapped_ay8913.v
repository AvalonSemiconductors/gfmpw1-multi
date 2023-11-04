`default_nettype none

module wrapped_ay8913(
`ifdef USE_POWER_PINS
	inout vdd,
	inout vss,
`endif
	input wb_clk_i,
	input rst_n,
	input [7:0] io_in_1,
	input [1:0] io_in_2,
	output [27:0] io_out,
    input [1:0] custom_settings
);

wire [3:0] pwms;
wire [7:0] raw_sample;
wire DAC_clk;
wire DAC_le;
wire DAC_dat;

/*
 * Pinout:
 * data [7:0]
 * pwms [3:0]
 * NC
 * NC
 * BDIR
 * BC1
 * NC
 * DAC Dat
 * DAC LEb
 * DAC CLK
 * raw_sample [7:0]
*/
assign io_out = {raw_sample, DAC_clk, DAC_le, DAC_dat, 1'b0, 1'b0, 1'b0, 2'b00, pwms, 8'h00};

tt_um_rejunity_ay8913 tt_um_rejunity_ay8913(
    .clk(wb_clk_i),
    .rst_n(rst_n),
    .data(io_in_1),
    .master_clock_control(custom_settings),
    .bdir(io_in_2[0]),
    .bc1(io_in_2[1]),
    .pwms(pwms),
    .raw_sample(raw_sample),
    .DAC_clk(DAC_clk),
    .DAC_le(DAC_le),
    .DAC_dat(DAC_dat)
);

endmodule
