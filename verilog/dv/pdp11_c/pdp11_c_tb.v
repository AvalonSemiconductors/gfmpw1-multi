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

module pdp11_c_tb;
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

	wire [15:0] bus_out = mprj_io[20:5];
	reg [15:0] bus_in;
	wire latch_enable = mprj_io[21];
	wire bus_dir = mprj_io[22];
	wire OEb = mprj_io[23];
	wire WEb = mprj_io[24];
	wire is_halted = mprj_io[25];
	assign mprj_io[20:5] = bus_dir ? bus_in : 16'hzzzz;

	//TRANSPARENT address latch
	reg [15:0] addr_latch;
	wire [15:0] full_addr = latch_enable ? bus_out : addr_latch;

	wire is_r4r5 = full_addr == 16'hFF30 || full_addr == 16'hFF32;
	wire is_r2r3 = full_addr == 16'hFF48 || full_addr == 16'hFF4C;
	
	reg [15:0] memory [32767:0];
	
	initial begin
		clock = 0;
		design_rst = 0;
		bus_in = 0;
		addr_latch = 0;
		for(integer i = 0; i < 32768; i=i+1) begin
			memory[i] = 16'h0000;
		end
		$readmemh("test.txt", memory, 0, 32767);
	end

	always @(negedge latch_enable) addr_latch <= bus_out;
	
	always @(posedge WEb) begin
		memory[full_addr>>1] <= bus_out;
		if(full_addr == 16'hFE00) begin
			$write("%c", bus_out[7:0]);
			$fflush();
			test = 1024;
		end
	end
	
	always @(negedge OEb) begin
		if(full_addr >= 16'hFE02 && full_addr <= 16'hFE12) begin
			bus_in <= 16'h0188;
		end else bus_in = memory[full_addr>>1];
	end

	integer test;
	initial begin
		test = 1200;

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
	
	integer counter = 0;
	integer failures = 0;
	initial begin
		@(posedge gpio);
		@(negedge gpio);
		@(posedge gpio);
		$dumpfile("pdp11_c.vcd");
		$dumpvars(1, pdp11_c_tb);
		$dumpvars(1, pdp11_c_tb.uut.chip_core.mprj);
		$dumpvars(0, pdp11_c_tb.uut.chip_core.mprj.multiplexer);
		$dumpvars(0, pdp11_c_tb.uut.chip_core.mprj.wrapped_pdp11);
		repeat (4) @(posedge clock);
		#10;
		design_rst = 1;
		$display("Reset released");
		@(posedge clock);
		@(posedge clock);
		@(posedge clock);
		
		while(!is_halted) begin
			repeat(16) @(posedge clock);
		end
		$display("\nHALT\n");
		
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
		.FILENAME("pdp11_c.hex")
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
