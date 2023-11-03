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

module qcpu_tb;
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
	wire Q = mprj_io[37];
	
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
	
	integer failures = 0;
	reg [7:0] buff;
	reg [7:0] buff2;
	integer counter = 0;
	initial begin
		@(posedge gpio);
		@(negedge gpio);
		@(posedge gpio);
		$dumpfile("qcpu.vcd");
		$dumpvars(1, qcpu_tb);
		$dumpvars(0, qcpu_tb.W25Q128JVxIM);
		$dumpvars(1, qcpu_tb.uut.chip_core.mprj);
		$dumpvars(0, qcpu_tb.uut.chip_core.mprj.multiplexer);
		$dumpvars(0, qcpu_tb.uut.chip_core.mprj.wrapped_qcpu);
		repeat (4) @(posedge clock);
		design_rst = 1;
		wait(PORTA == 8'h55);
		wait(PORTA == 8'h5F);
		$display("PORT OUT");
		wait(PORTA == 8'h61);
		wait(PORTA == 8'h37);
		$display("LDC");
		PORTB_in = 8'h65;
		wait(PORTA == 8'h65);
		PORTB_in = 8'h3F;
		wait(PORTA == 8'h3F);
		$display("PORT IN");
		
		buff = 0;
		wait(TXD == 0);
		@(posedge clock);
		repeat(8) begin
			repeat(7) @(posedge clock);
			buff = {TXD, buff[7:1]};
		end
		repeat(7) @(posedge clock);
		failures += TXD != 1;
		repeat(7) @(posedge clock);
		failures += TXD != 1;
		failures += buff != 8'h69;
		$display("UART TX");
		
		buff = 8'h53;
		RXD = 0;
		repeat(8) begin
			repeat(7) @(posedge clock);
			RXD = buff[0];
			buff = {1'b0, buff[7:1]};
		end
		repeat(7) @(posedge clock);
		RXD = 1;
		repeat(7) @(posedge clock);
		repeat(7) @(posedge clock);
		wait(PORTA == 8'h53);
		$display("UART RX");
		
		wait(SCLK == 1);
		@(posedge clock);
		buff = 0;
		buff2 = 8'h27;
		buff2 = {buff2[6:0], 1'b0};
		DI = 0;
		repeat(8) begin
			failures += SCLK != 1;
			buff = {buff[6:0], DO};
			repeat(5) @(posedge clock);
			failures += SCLK != 0;
			DI = buff2[7];
			buff2 = {buff2[6:0], 1'b0};
			repeat(5) @(posedge clock);
		end
		failures += SCLK != 0;
		failures += buff != 8'h69;
		wait(PORTA == 8'h27);
		$display("SPI");
		
		wait(PORTA == 8'h03);
		wait(PORTA == 8'h00);
		wait(PORTA == 8'h14);
		wait(PORTA == 8'h00);
		wait(PORTA == 8'h24);
		wait(PORTA == 8'h00);
		$display("Timer");
		repeat(30) begin
			@(posedge M1);
			@(negedge M1);
		end
		
		intb <= 0;
		@(posedge clock);
		@(posedge clock);
		@(posedge clock);
		@(posedge clock);
		intb <= 1;
		wait(PORTA == 8'h6C);
		$display("Interrupt");

		wait(PORTA == 8'h66);
		wait(PORTA == 8'h00);
		wait(PORTA == 8'h11);
		wait(PORTA == 8'h05);
		wait(PORTA == 8'h80);
		wait(PORTA == 8'h01);
		wait(PORTA == 8'h02);
		wait(PORTA == 8'h81);
		wait(PORTA == 8'h40);
		wait(PORTA == 8'h85);
		wait(PORTA == 8'hC2);
		wait(PORTA == 8'h61);
		wait(PORTA == 8'hC2);
		wait(PORTA == 8'h85);
		wait(PORTA == 8'h0B);
		wait(PORTA == 8'h0A);
		wait(PORTA == 8'h15);
		wait(PORTA == 8'h2A);
		wait(PORTA == 8'h54);
		wait(PORTA == 8'h04);
		wait(PORTA == 8'h05);
		wait(PORTA == 8'h07);
		wait(PORTA == 8'h04);
		wait(PORTA == 8'h07);
		wait(PORTA == 8'h55);
		wait(PORTA == 8'hAA);
		wait(PORTA == 8'h05);
		wait(PORTA == 8'h01);
		wait(PORTA == 8'h04);
		wait(PORTA == 8'h00);
		wait(PORTA == 8'h82);
		wait(PORTA == 8'h04);
		wait(PORTA == 8'h00);
		wait(PORTA == 8'h06);
		wait(PORTA == 8'hC1);
		wait(PORTA == 8'h04);
		wait(PORTA == 8'hBF);
		wait(PORTA == 8'h04);
		wait(PORTA == 8'hFE);
		wait(PORTA == 8'h05);
		wait(PORTA == 8'h08);
		wait(PORTA == 8'h04);
		wait(PORTA == 8'h00);
		wait(PORTA == 8'h07);
		wait(PORTA == 8'h09);
		wait(PORTA == 8'h04);
		wait(PORTA == 8'hF5);
		wait(PORTA == 8'h05);
		wait(PORTA == 8'h00);
		wait(PORTA == 8'h07);
		wait(PORTA == 8'hFF);
		wait(PORTA == 8'h04);
		wait(PORTA == 8'hFD);
		wait(PORTA == 8'h05);
		wait(PORTA == 8'h72);
		$display("Remaining instructions");

		counter = 0;
		while(PORTA != 8'h04) begin
			counter = counter + 1;
			@(posedge clock);
		end
		$display("%d", counter);
		failures += counter < 300 || counter > 420;
		$display("Timer interrupt");
		@(posedge M1);
		@(negedge M1);
		@(posedge M1);
		@(negedge M1);
		@(posedge M1);
		@(negedge M1);
		
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
		.FILENAME("qcpu.hex")
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
