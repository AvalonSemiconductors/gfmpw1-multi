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

module mc14500_tb;
	reg clock;
	reg design_clock;
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

	always #12.5 clock <= (clock === 1'b0);
	always #35 design_clock <= (design_clock === 1'b0);
	assign mprj_io[3] = (CSB == 1'b1) ? 1'b1 : 1'bz;
	assign mprj_io[0] = design_rst;
	assign mprj_io[37] = design_clock;
	
	wire [16:0] PC = mprj_io[29:13];
	reg [7:0] ROM [4095:0];
	wire [7:0] romval = ROM[PC[11:0]];
	assign mprj_io[12:5] = romval;
	reg SDI = 0;
	assign mprj_io[36] = SDI;
	wire FLAG_O = mprj_io[30];
	wire RR = mprj_io[31];
	wire SCLK = mprj_io[32];
	wire SDO = mprj_io[33];
	wire out_1 = mprj_io[34];
	wire out_2 = mprj_io[35];
	
	initial begin
		for(integer i = 0; i < 4096; i = i + 1) begin
			ROM[i] = 0;
		end
		$readmemh("pgm.txt", ROM, 0, 3*1024-1);
		clock = 0;
		design_clock = 0;
		design_rst = 0;
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
	
	reg [7:0] buff;
	reg [7:0] received [11:0];
	reg [3:0] ptr;
	integer failures = 0;
	initial begin
		@(posedge gpio);
		@(negedge gpio);
		@(posedge gpio);
		$dumpfile("mc14500.vcd");
		$dumpvars(1, mc14500_tb);
		$dumpvars(1, mc14500_tb.uut.chip_core.mprj);
		$dumpvars(0, mc14500_tb.uut.chip_core.mprj.multiplexer);
		$dumpvars(0, mc14500_tb.uut.chip_core.mprj.mc14500);
		repeat (4) @(posedge design_clock);
		#10;
		design_rst = 1;
		$display("Reset released");
		repeat (8) @(posedge design_clock);
		
		$write("Program output: ");
		$fflush();
		ptr = 0;
		repeat(12) begin
			buff = 0;
			repeat(9) begin
				wait(SCLK == 1);
				buff = {SDO, buff[7:1]};
				wait(SCLK == 0);
			end
			wait(SCLK == 1);
			wait(SCLK == 0);
			wait(SDO == 1);
			$write("%c", buff);
			$fflush();
			received[ptr] = buff;
			ptr = ptr + 1;
		end
		failures += received[0] != 8'h31;
		failures += received[1] != 8'h41;
		failures += received[2] != 8'h2A;
		failures += received[3] != 8'h32;
		failures += received[4] != 8'h45;
		failures += received[5] != 8'h3D;
		failures += received[6] != 8'h30;
		failures += received[7] != 8'h34;
		failures += received[8] != 8'h41;
		failures += received[9] != 8'h43;
		failures += received[10] != 8'h0D;
		failures += received[11] != 8'h0A;
		
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
		.FILENAME("mc14500.hex")
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
