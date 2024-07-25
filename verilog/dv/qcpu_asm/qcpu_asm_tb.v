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

`include "W25Q128JVxIM.v"

`timescale 1 ns / 1 ps

module qcpu_asm_tb;
	reg clock;
	reg RSTB;
	reg CSB;
	reg power1;
	reg design_rst;

	wire gpio;
	wire [37:0] mprj_io;
	
	// External clock is used by default.  Make this artificially fast for the
	// simulation.  Normally this would be a slow clock and the digital PLL
	// would be the fast clock.

	reg [7:0] PORTB_in;
	
	always #20 clock <= (clock === 1'b0);
	assign mprj_io[3] = (CSB == 1'b1) ? 1'b1 : 1'bz;
	assign mprj_io[0] = design_rst;
	
	wire [3:0] qspi_dat = mprj_io[8:5];
	wire qspi_cs = mprj_io[9];
	wire qspi_sclk = mprj_io[10];
	
	wire [7:0] PORTA = mprj_io[18:11];
	wire [7:0] PORTB = mprj_io[26:19];
	assign mprj_io[26:19] = PORTB_in;
	
	reg RXD;
	wire TXD = mprj_io[27];
	assign mprj_io[28] = RXD;
	wire SCLK = mprj_io[29];
	wire DO = mprj_io[30];
	reg DI;
	assign mprj_io[31] = DI;
	
	wire M1 = mprj_io[32];
	reg pause;
	assign mprj_io[34] = pause;
	
	reg intb;
	assign mprj_io[33] = intb;

	wire pwm = mprj_io[35];
	wire toggle = mprj_io[36];
	wire ROM_OEB = mprj_io[37];
	
	initial begin
		clock = 0;
		design_rst = 0;
		PORTB_in = 0;
		RXD = 1;
		DI = 0;
		intb = 1;
		pause = 0;
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
	
	initial begin
		@(posedge gpio);
		@(negedge gpio);
		@(posedge gpio);
		$dumpfile("qcpu_asm.vcd");
		$dumpvars(1, qcpu_asm_tb);
		$dumpvars(0, qcpu_asm_tb.W25Q128JVxIM);
		$dumpvars(1, qcpu_asm_tb.uut.chip_core.mprj);
		$dumpvars(0, qcpu_asm_tb.uut.chip_core.mprj.multiplexer);
		$dumpvars(0, qcpu_asm_tb.uut.chip_core.mprj.wrapped_qcpu);
		repeat (4) @(posedge clock);
		design_rst = 1;
		wait(PORTA == 8'h55);
		
		$display("%c[1;32m", 27);
		`ifdef GL
		$display("Monitor: Test (GL) Passed");
		`else
		$display("Monitor: Test (RTL) Passed");
		`endif
		$display("%c[0m", 27);
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
		.FILENAME("qcpu_asm.hex")
	) spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(),			// not used
		.io3()			// not used
	);
	
	W25Q128JVxIM W25Q128JVxIM(
		.CSn(qspi_cs),
		.CLK(qspi_sclk),
		.DIO(mprj_io[5]),
		.DO(mprj_io[6]),
		.WPn(mprj_io[7]),
		.HOLDn(mprj_io[8])
	);
	
endmodule

`default_nettype wire
