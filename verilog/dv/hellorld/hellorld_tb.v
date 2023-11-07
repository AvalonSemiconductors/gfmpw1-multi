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

module hellorld_tb;
	reg clock;
	reg RSTB;
	reg CSB;
	reg power1;
	reg design_rst;

	wire gpio;
	wire [37:0] mprj_io;
	wire checkbit;

	// External clock is used by default.  Make this artificially fast for the
	// simulation.  Normally this would be a slow clock and the digital PLL
	// would be the fast clock.

	always #15 clock <= (clock === 1'b0);
	assign mprj_io[3] = (CSB == 1'b1) ? 1'b1 : 1'bz;
	assign mprj_io[0] = design_rst;
	
	wire TXD = mprj_io[5];
	
	initial begin
		clock = 0;
		design_rst = 0;
	end

	integer test;
	initial begin
		test = 1175;

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
	
	reg [7:0] buff;
	reg [7:0] string [10:0];
	reg [3:0] counter;
	integer failures = 0;
	initial begin
		@(posedge gpio);
		@(negedge gpio);
		@(posedge gpio);
		repeat (4) @(posedge clock);
		#10;
		design_rst = 1;
		$display("Reset released");
		$dumpfile("hellorld.vcd");
		$dumpvars(1, hellorld_tb);
		$dumpvars(1, hellorld_tb.uut.chip_core.mprj);
		$dumpvars(0, hellorld_tb.uut.chip_core.mprj.multiplexer);
		$dumpvars(0, hellorld_tb.uut.chip_core.mprj.hellorld);
		
		repeat(5) begin
			buff = 0;
			counter = 0;
			repeat(11) begin
				wait(TXD == 0);
				@(posedge clock);
				repeat(8) begin
					repeat(5) @(posedge clock);
					buff = {TXD, buff[7:1]};
				end
				repeat(5) @(posedge clock);
				failures += TXD != 1;
				string[counter] = buff;
				counter = counter + 1;
				$write("%c", buff);
			end
			failures += string[0] != 8'h48;
			failures += string[1] != 8'h65;
			failures += string[2] != 8'h6C;
			failures += string[3] != 8'h6C;
			failures += string[4] != 8'h6F;
			failures += string[5] != 8'h72;
			failures += string[6] != 8'h6C;
			failures += string[7] != 8'h64;
			failures += string[8] != 8'h21;
			failures += string[9] != 13;
			failures += string[10] != 10;
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
		.FILENAME("hellorld.hex")
	) spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(),			// not used
		.io3()			// not used
	);

endmodule
`default_nettype wire
