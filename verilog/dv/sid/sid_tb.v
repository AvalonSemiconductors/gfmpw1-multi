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

module sid_tb;
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
	reg CEb;
	reg OEb;
	reg [5:0] addr_in;

	// External clock is used by default.  Make this artificially fast for the
	// simulation.  Normally this would be a slow clock and the digital PLL
	// would be the fast clock.

	always #12.5 clock <= (clock === 1'b0);
	assign mprj_io[3] = (CSB == 1'b1) ? 1'b1 : 1'bz;
	assign mprj_io[0] = design_rst;
	
	wire [7:0] data_out = mprj_io[12:5];
	
	assign mprj_io[12:5] = !OEb ? 8'hzz : data_in;
	assign mprj_io[19] = WEb;
	assign mprj_io[20] = OEb;
	assign mprj_io[21] = CEb;
	
	assign mprj_io[18:13] = addr_in;
	wire DAC_dat_1 = mprj_io[22];
	wire DAC_le = mprj_io[23];
	wire DAC_clk = mprj_io[24];
	wire DAC_dat_2 = mprj_io[25];
	
	wire [11:0] dac_sample_1;
	wire [11:0] dac_sample_2;
	
	initial begin
		clock = 0;
		design_rst = 0;
		data_in = 0;
		WEb = 1'b1;
		CEb = 1'b1;
		OEb = 1'b1;
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
	
	integer failures = 0;
	reg [11:0] last_sample = 0;
	reg flag;
	reg which;
	integer counter1, counter2, counter3;
	wire [11:0] dac_sample = which ? dac_sample_2 : dac_sample_1;
	wire [11:0] dac_sample_denoise = dac_sample & 12'hFF8;

	initial begin
		which = 0;
		@(posedge gpio);
		@(negedge gpio);
		@(posedge gpio);
		$dumpfile("sid.vcd");
		$dumpvars(1, sid_tb);
		$dumpvars(1, sid_tb.uut.chip_core.mprj);
		$dumpvars(0, sid_tb.uut.chip_core.mprj.multiplexer);
		$dumpvars(0, sid_tb.uut.chip_core.mprj.sid);
		repeat (4) @(posedge clock);
		design_rst = 1;
		repeat (32) @(posedge clock);

		repeat(2) begin
			addr_in = which ? 32 : 0;
			data_in = 8'h25;
			@(posedge clock);
			CEb = 0;
			WEb = 0;
			@(posedge clock);
			WEb = 1;
			OEb = 0;
			@(posedge clock);
			failures += data_out != 8'h25;
			OEb = 1;
			CEb = 1;
			@(posedge clock);

			addr_in = 1 + (which ? 32 : 0);
			data_in = 8'h66;
			@(posedge clock);
			CEb = 0;
			WEb = 0;
			@(posedge clock);
			WEb = 1;
			addr_in = 2 + (which ? 32 : 0);
			data_in = 8'h00;
			@(posedge clock);
			WEb = 0;
			@(posedge clock);
			WEb = 1;
			addr_in = 3 + (which ? 32 : 0);
			data_in = 8'h08;
			@(posedge clock);
			WEb = 0;
			@(posedge clock);
			WEb = 1;
			addr_in = 5 + (which ? 32 : 0);
			data_in = 8'h20;
			@(posedge clock);
			WEb = 0;
			@(posedge clock);
			WEb = 1;
			addr_in = 6 + (which ? 32 : 0);
			data_in = 8'hD0;
			@(posedge clock);
			WEb = 0;
			@(posedge clock);
			WEb = 1;
			addr_in = 24 + (which ? 32 : 0);
			data_in = 8'h0F;
			@(posedge clock);
			WEb = 0;
			@(posedge clock);
			WEb = 1;
			addr_in = 4 + (which ? 32 : 0);
			data_in = 17;
			@(posedge clock);
			WEb = 0;
			@(posedge clock);
			CEb = 1;
			WEb = 1;

			wait(dac_sample == 12'h000 || which);
			wait(dac_sample == 12'h800);
			last_sample = dac_sample_denoise;

			flag = 0;
			counter1 = 0;
			counter2 = 0;
			counter3 = 0;
			repeat(25) begin
				$display("%d", dac_sample_denoise);
				wait(dac_sample_denoise != last_sample);

				if(dac_sample_denoise > last_sample) begin
					counter2 = 0;
					counter1 = counter1 + 1;
					if(!flag) begin
						counter3 = counter3 + 1;
					end
					flag = 1;
				end else if(dac_sample_denoise < last_sample) begin
					counter1 = 0;
					counter2 = counter2 + 1;
					if(flag) begin
						counter3 = counter3 + 1;
					end
					flag = 0;
				end

				failures += !(counter1 < 3 && counter2 < 3);

				last_sample = dac_sample_denoise;
			end
			failures += counter3 < 8;

			CEb = 0;
			addr_in = 4 + (which ? 32 : 0);
			data_in = 16;
			@(posedge clock);
			WEb = 0;
			@(posedge clock);
			WEb = 1;
			CEb = 1;

			counter3 = 0;
			counter2 = 0;
			while(counter2 != 5) begin
				repeat(25) @(posedge clock);
				counter3 = counter3 + 1;
				if(dac_sample == 2048) begin
					counter2 = counter2 + 1;
				end else begin
					counter2 = 0;
				end
			end
			$display("%d", counter3);
			failures += counter3 < 144;
			which = !which;
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
		.FILENAME("sid.hex")
	) spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(),			// not used
		.io3()			// not used
	);
	
	DAC7611 DAC7611_1(
		.clk(DAC_clk),
		.dat(DAC_dat_1),
		.leb(DAC_le),
		.rst_b(design_rst),
		.sample(dac_sample_1)
	);
	
	DAC7611 DAC7611_2(
		.clk(DAC_clk),
		.dat(DAC_dat_2),
		.leb(DAC_le),
		.rst_b(design_rst),
		.sample(dac_sample_2)
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
