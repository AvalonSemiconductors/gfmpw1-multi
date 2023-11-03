// SPDX-FileCopyrightText: 2023 Tholin
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

`timescale 1 ns / 1 ps

module sn76489_tb;
	reg clock;
	reg RSTB;
	reg CSB;
	reg power1;
	reg design_rst;

	wire gpio;
	wire [37:0] mprj_io;
	wire checkbit;
	
	reg [7:0] data_in;
	reg WEb;

	// External clock is used by default.  Make this artificially fast for the
	// simulation.  Normally this would be a slow clock and the digital PLL
	// would be the fast clock.

	always #12.5 clock <= (clock === 1'b0);
	assign mprj_io[3] = (CSB == 1'b1) ? 1'b1 : 1'bz;
	assign mprj_io[0] = design_rst;
	
	assign mprj_io[12:5] = data_in;
	assign mprj_io[19] = WEb;
	
	wire [4:0] pwms = mprj_io[17:13];
	wire [7:0] raw_sample = mprj_io[32:25];
	wire DAC_dat = mprj_io[22];
	wire DAC_le = mprj_io[23];
	wire DAC_clk = mprj_io[24];
	
	wire [11:0] dac_sample;
	
	initial begin
		clock = 0;
		design_rst = 0;
		data_in = 0;
		WEb = 1'b1;
	end

	integer test;
	initial begin
		test = 2048;

		while(test > 2)  begin
			repeat (50) @(posedge clock);
			$fflush();
			test -= 1;
		end
			$display("%c[1;31m",27);
			`ifdef GL
				$display ("Monitor: TIMEOUT (GL)");
			`else
				$display ("Monitor: TIMEOUT (RTL)");
			`endif
			$display("%c[0m",27);
		$finish;
	end
	
	integer vals [9:0];
	integer index = 0;
	integer counter = 0;
	integer failures = 0;
	reg [7:0] prev_sample = 0;
	initial begin
		@(posedge gpio);
		@(negedge gpio);
		@(posedge gpio);
		$dumpfile("sn76489.vcd");
		$dumpvars(1, sn76489_tb);
		$dumpvars(1, sn76489_tb.uut.chip_core.mprj);
		$dumpvars(0, sn76489_tb.uut.chip_core.mprj.multiplexer);
		$dumpvars(0, sn76489_tb.uut.chip_core.mprj.wrapped_sn76489);
		repeat (4) @(posedge clock);
		design_rst = 1;
		repeat (32) @(posedge clock);
		data_in = 8'b10000000;
		WEb = 0;
		@(posedge clock);
		WEb = 1;
		@(posedge clock);
		data_in = 8'b00001100;
		WEb = 0;
		@(posedge clock);
		WEb = 1;
		@(posedge clock);
		data_in = 8'b10010000;
		WEb = 0;
		@(posedge clock);
		WEb = 1;
		@(posedge clock);
		data_in = 8'b10100000;
		WEb = 0;
		@(posedge clock);
		WEb = 1;
		@(posedge clock);
		data_in = 8'b00000110;
		WEb = 0;
		@(posedge clock);
		WEb = 1;
		@(posedge clock);
		data_in = 8'b10110000;
		WEb = 0;
		@(posedge clock);
		WEb = 1;
		@(posedge clock);
		data_in = 8'b11000000;
		WEb = 0;
		@(posedge clock);
		WEb = 1;
		@(posedge clock);
		data_in = 8'b00011000;
		WEb = 0;
		@(posedge clock);
		WEb = 1;
		@(posedge clock);
		data_in = 8'b11011000;
		WEb = 0;
		@(posedge clock);
		WEb = 1;
		@(posedge clock);
		
		wait(raw_sample != 8'b00000000);
		wait(raw_sample == 8'b00000000);
		repeat(192) @(posedge clock);
		prev_sample = raw_sample;
		@(posedge clock);
		failures += !(raw_sample > prev_sample);
		repeat(191) @(posedge clock);
		prev_sample = raw_sample;
		@(posedge clock);
		failures += !(raw_sample < prev_sample);

		data_in = 8'b10111111;
		WEb = 0;
		@(posedge clock);
		WEb = 1;
		@(posedge clock);
		data_in = 8'b10011111;
		WEb = 0;
		@(posedge clock);
		WEb = 1;
		@(posedge clock);
		wait(raw_sample == 8'b00000000);
		repeat(384) @(posedge clock);
		prev_sample = raw_sample;
		@(posedge clock);
		failures += !(raw_sample > prev_sample);
		failures += raw_sample != 8'h0A;
		repeat(48) @(posedge clock);
		failures += dac_sample != 12'h0A2;
		data_in = 8'b11011111;
		WEb = 0;
		@(posedge clock);
		WEb = 1;
		@(posedge clock);
		wait(raw_sample == 8'b00000000);

		data_in = 8'b11100100;
		WEb = 0;
		@(posedge clock);
		WEb = 1;
		@(posedge clock);
		data_in = 8'b11110001;
		WEb = 0;
		@(posedge clock);
		WEb = 1;
		@(posedge clock);

		repeat(10) begin
			wait(raw_sample == 8'b00000000);
			counter = 0;
			while(raw_sample == 0) begin
				counter = counter + 1;
				@(posedge clock);
			end
			failures += raw_sample != 8'h32;
			repeat(48) @(posedge clock);
			failures += dac_sample != 12'h32C;
			$display("Noise delay %d %d", index, counter);
			vals[index] = counter;
			index = index + 1;
		end

		counter = 0;
		repeat(10) begin
			index = 0;
			repeat(10) begin
				failures += vals[index] == vals[counter] && index != counter;
				index = index + 1;
			end
			counter = counter + 1;
		end
		
		if(!failures) begin
			$display("%c[1;32m", 27);
			`ifdef GL
			$display("Monitor: Test (GL) Passed");
			`else
			$display("Monitor: Test (RTL) Passed");
			`endif
			$display("%c[0m", 27);
		end else begin
			$display("%c[1;31m",27);
			`ifdef GL
				$display ("Monitor: Test (GL) Failed");
			`else
				$display ("Monitor: Test (RTL) Failed");
			`endif
			$display("%c[0m",27);
		end
		$finish();
	end

	initial begin
		RSTB <= 1'b0;
		CSB  <= 1'b1;		// Force CSB high
		#2000;
		RSTB <= 1'b1;	    	// Release reset
		#3_000_000;
		CSB = 1'b0;		// CSB can be released
	end

	initial begin		// Power-up sequence
		power1 <= 1'b0;
		#100;
		power1 <= 1'b1;
	end

	wire flash_csb;
	wire flash_clk;
	wire flash_io0;
	wire flash_io1;

	wire VDD = power1;
	wire VSS = 1'b0;

	caravel uut (
		.VSS(VSS),
		.VDD(VDD),
		.clock    (clock),
		.gpio     (gpio),
		.mprj_io  (mprj_io),
		.flash_csb(flash_csb),
		.flash_clk(flash_clk),
		.flash_io0(flash_io0),
		.flash_io1(flash_io1),
		.resetb	  (RSTB)
	);

	spiflash #(
		.FILENAME("sn76489.hex")
	) spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(),			// not used
		.io3()			// not used
	);
	
	DAC7611 DAC7611(
		.clk(DAC_clk),
		.dat(DAC_dat),
		.leb(DAC_le),
		.rst_b(design_rst),
		.sample(dac_sample)
	);

endmodule

module DAC7611(
	input clk,
	input dat,
	input leb,
	input rst_b,
	output [11:0] sample
);

reg [11:0] serial_buff;
reg [11:0] sample_latch;
assign sample = leb ? sample_latch : serial_buff;

always @(posedge clk or negedge rst_b) begin
	if(rst_b) begin
		serial_buff <= {serial_buff[10:0], dat};
	end else begin
		serial_buff <= 12'h000;
	end
end

always @(posedge leb or negedge rst_b) begin
	if(rst_b) begin
		sample_latch <= serial_buff;
	end else begin
		sample_latch <= 12'h000;
	end
end

endmodule


`default_nettype wire
