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

module pdp11_tb;
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

	always #25 clock <= (clock === 1'b0);
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
	wire [6:0] PORTA_out = mprj_io[37:31];
	reg [6:0] PORTA_in;
	reg PORTA_dir;
	assign mprj_io[37:31] = PORTA_dir ? PORTA_in : 7'hzz;

	//TRANSPARENT address latch
	reg [15:0] addr_latch;
	wire [15:0] full_addr = latch_enable ? bus_out : addr_latch;
	
	initial begin
		clock = 0;
		design_rst = 0;
		bus_in = 0;
		addr_latch = 0;
		PORTA_in = 0;
		PORTA_dir = 0;
	end

	always @(negedge latch_enable) addr_latch <= bus_out;

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
	
	integer counter = 0;
	integer failures = 0;
	integer prev_pc;
	integer prev_psw;
	initial begin
		@(posedge gpio);
		@(negedge gpio);
		@(posedge gpio);
		$dumpfile("pdp11.vcd");
		$dumpvars(1, pdp11_tb);
		$dumpvars(1, pdp11_tb.uut.chip_core.mprj);
		$dumpvars(0, pdp11_tb.uut.chip_core.mprj.multiplexer);
		$dumpvars(0, pdp11_tb.uut.chip_core.mprj.wrapped_pdp11);
		repeat (4) @(posedge clock);
		#10;
		design_rst = 1;
		$display("Reset released");
		@(posedge clock);
		@(posedge clock);
		@(posedge clock);
		#3;
		failures += latch_enable != 1;
		failures += OEb != 1;
		failures += WEb != 1;
		failures += bus_dir != 0;
		failures += bus_out != 16'h0000;
		@(negedge clock);
		#3;
		failures += latch_enable != 0;
		failures += OEb != 1;
		failures += WEb != 1;
		failures += bus_dir != 0;
		failures += bus_out != 16'h0000;
		@(posedge clock);
		#3;
		failures += latch_enable != 0;
		failures += OEb != 0;
		failures += WEb != 1;
		failures += bus_dir != 1;
		failures += full_addr != 16'h0000;
		bus_in = 16'h0A02; //CLR R2
		@(posedge clock);
		#3;
		failures += latch_enable != 0;
		failures += OEb != 1;
		failures += WEb != 1;
		failures += bus_dir != 1;
		bus_in = 0;
		@(posedge clock);
		#3;
		failures += latch_enable != 1;
		failures += OEb != 1;
		failures += WEb != 1;
		failures += bus_dir != 0;
		failures += bus_out != 16'h0002;
		@(posedge clock);
		#3;
		failures += latch_enable != 0;
		failures += OEb != 0;
		failures += WEb != 1;
		failures += bus_dir != 1;
		failures += full_addr != 16'h0002;
		bus_in = 16'h0A4A; //COM (R2)
		@(posedge clock);
		#3;
		failures += latch_enable != 1;
		failures += OEb != 1;
		failures += WEb != 1;
		failures += bus_dir != 0;
		failures += bus_out != 16'h0000;
		bus_in = 0;
		@(posedge clock);
		#3;
		failures += latch_enable != 0;
		failures += OEb != 0;
		failures += WEb != 1;
		failures += bus_dir != 1;
		failures += full_addr != 16'h0000;
		bus_in = 16'h0A5C;
		@(posedge clock);
		#3;
		failures += latch_enable != 0;
		failures += OEb != 1;
		failures += WEb != 1;
		failures += bus_dir != 1;
		bus_in = 0;
		@(posedge clock);
		#3;
		failures += latch_enable != 0;
		failures += OEb != 1;
		failures += WEb != 0;
		failures += bus_dir != 0;
		failures += bus_out != 16'hF5A3;
		@(posedge clock);
		#3;
		counter = 0;
		repeat(15) begin
			failures += latch_enable != 1;
			failures += OEb != 1;
			failures += WEb != 1;
			@(posedge clock);
			#3;
			failures += OEb != 0;
			failures += WEb != 1;
			failures += full_addr != 16'h0004 + counter;
			counter = counter + 2;
			bus_in = 16'h0A82; //INC R2
			@(posedge clock);
			#3;
			failures += OEb != 1;
			failures += WEb != 1;
			bus_in = 0;
			@(posedge clock);
			#3;
		end
		failures += latch_enable != 1;
		failures += OEb != 1;
		failures += WEb != 1;
		@(posedge clock);
		#3;
		failures += OEb != 0;
		failures += WEb != 1;
		failures += full_addr != 16'h0022;
		counter = counter + 2;
		bus_in = 16'h0AC2; //DEC R2
		@(posedge clock);
		#3;
		failures += OEb != 1;
		failures += WEb != 1;
		bus_in = 0;
		@(posedge clock);
		#3 failures += latch_enable != 1;
		@(posedge clock);
		#3 failures += latch_enable != 0 || OEb != 0 || full_addr != 16'h0024;
		bus_in = 16'h0B12; //NEG (R2)+
		@(posedge clock);
		#3 failures += latch_enable != 1;
		@(posedge clock);
		#3 failures += latch_enable != 0 || OEb != 0 || full_addr != 16'h000E;
		bus_in = 16'hC0D0;
		@(posedge clock);
		#3 failures += latch_enable != 0 || OEb != 1 || WEb != 1;
		bus_in = 0;
		@(posedge clock);
		#3 failures += latch_enable != 0 || WEb != 0;
		failures += bus_out != 16'h3F30;
		@(posedge clock);
		#3 failures += latch_enable != 1 || WEb != 1 || OEb != 1;
		@(posedge clock);
		#3 failures += OEb != 0 || full_addr != 16'h0026;
		bus_in = 16'h0BCA; //TST (R2)
		@(posedge clock);
		#3 failures += OEb != 1;
		bus_in = 0;
		failures += latch_enable != 1;
		@(posedge clock);
		#3 failures += latch_enable != 0 || OEb != 0 || full_addr != 16'h0010;
		bus_in = 16'h8177;
		@(posedge clock);
		#3;
		//TODO: output status flags on pins, check after each instr here
		@(posedge clock);
		#3 failures += latch_enable != 1;
		@(posedge clock);
		#3 failures += OEb != 0 || full_addr != 16'h0028;
		bus_in = 16'h0C9A; //ASR @(R2)+
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 1 || latch_enable != 1;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 0 || latch_enable != 0 || full_addr != 16'h0010;
		bus_in = 16'h0330;
		@(posedge clock);
		#3 failures += OEb != 1 || latch_enable != 1;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 0 || latch_enable != 0 || full_addr != 16'h0330;
		bus_in = 16'h806B;
		@(posedge clock);
		#3 failures += OEb != 1 || latch_enable != 0 || WEb != 1;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 0 || full_addr != 16'h0330;
		failures += bus_out != 16'hC035;
		@(posedge clock);
		#3 failures += WEb != 1 || latch_enable != 1 || OEb != 1;
		@(posedge clock);
		#3 failures += OEb != 0 || full_addr != 16'h002A || latch_enable != 0;
		bus_in = 16'h0CCA; //ASL (R2)
		@(posedge clock);
		#3 failures += OEb != 1 || latch_enable != 1;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 0 || full_addr != 16'h0012;
		bus_in = 16'hCCC9;
		@(posedge clock);
		#3 failures += OEb != 1 || latch_enable != 0;
		bus_in = 0;
		@(posedge clock);
		#3 failures += WEb != 0 || OEb != 1 || latch_enable != 0 || bus_out != 16'h9992;
		@(posedge clock);
		#3 failures += WEb != 1 || OEb != 1 || latch_enable != 1 || bus_dir != 0;
		@(posedge clock);
		#3 failures += latch_enable != 0 || OEb != 0 || WEb != 1 || full_addr != 16'h002C;
		bus_in = 16'h0C22; //ROR -(R2)
		@(posedge clock);
		#3 failures += latch_enable != 1 || OEb != 1 || WEb != 1;
		bus_in = 0;
		@(posedge clock);
		#3 failures += latch_enable != 0 || OEb != 0 || WEb != 1 || full_addr != 16'h0010;
		bus_in = 16'h0D03;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 1 || latch_enable != 0;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 0 || latch_enable != 0;
		failures += bus_out != 16'h8681;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 1 || latch_enable != 1;
		@(posedge clock);
		#3 failures += OEb != 0 || latch_enable != 0 || full_addr != 16'h002E;
		bus_in = 16'h0C6A; //ROL @-(R2)
		@(posedge clock);
		#3 failures += OEb != 1 || latch_enable != 1;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 0 || WEb != 1 || latch_enable != 0 || full_addr != 16'h000E;
		bus_in = 16'hFFFC;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 1 || latch_enable != 1;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 0 || WEb != 1 || latch_enable != 0 || full_addr != 16'hFFFC;
		bus_in = 16'h6660;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 1 || latch_enable != 0;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 0 || latch_enable != 0;
		failures += bus_out != 16'hCCC1;
		@(posedge clock);
		#3 failures += OEb != 1 || latch_enable != 1;
		@(posedge clock);
		#3 failures += OEb != 0 || full_addr != 16'h0030;
		bus_in = 16'h00F2; //SWAB 16(R2)
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 1 || latch_enable != 1;
		@(posedge clock);
		#3 failures += OEb != 0 || WEb != 1 || latch_enable != 0 || full_addr != 16'h0032;
		bus_in = 16'h0010;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 1 || latch_enable != 1;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 0 || WEb != 1 || latch_enable != 0 || full_addr != 16'h001E;
		bus_in = 16'h1733;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 1 || latch_enable != 0;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 0 || latch_enable != 0;
		failures += bus_out != 16'h3317;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 1 || latch_enable != 1;
		@(posedge clock);
		#3 failures += OEb != 0 || full_addr != 16'h0034;
		bus_in = 16'h0C4A; //ROL (R2)
		@(posedge clock);
		#3 bus_in = 0;
		@(posedge clock);
		bus_in = 16'h8002;
		#3 failures += OEb != 0 || full_addr != 16'h000E;
		@(posedge clock);
		bus_in = 0;
		@(posedge clock);
		#3 failures += WEb != 0 || bus_out != 16'h0004;
		@(posedge clock);
		#3 failures += latch_enable != 1;
		@(posedge clock);
		#3 failures += OEb != 0 || full_addr != 16'h0036;
		bus_in = 16'h0B4A; //ADC (R2)
		@(posedge clock);
		#3 failures += OEb != 1 || latch_enable != 1;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 0 || full_addr != 16'h000E;
		bus_in = 16'h1010;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 1;
		bus_in = 0;
		@(posedge clock);
		#3 failures += WEb != 0 || bus_out != 16'h1011;
		@(posedge clock);
		#3 failures += latch_enable != 1 || WEb != 1;
		@(posedge clock);
		#3 failures += OEb != 0 || full_addr != 16'h0038;
		bus_in = 16'h0B4A; //ADC (R2)
		@(posedge clock);
		#3 failures += OEb != 1 || latch_enable != 1;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 0 || full_addr != 16'h000E;
		bus_in = 16'h1010;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 1;
		bus_in = 0;
		@(posedge clock);
		#3 failures += WEb != 0 || bus_out != 16'h1010;
		@(posedge clock);
		#3 failures += latch_enable != 1 || WEb != 1;
		@(posedge clock);
		#3 failures += OEb != 0 || full_addr != 16'h003A;
		bus_in = 16'h0BBA; //SBC @512(R2)
		@(posedge clock);
		#3 failures += OEb != 1 || latch_enable != 1;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 0 || full_addr != 16'h003C;
		bus_in = 16'h0200;
		@(posedge clock);
		#3 failures += OEb != 1 || latch_enable != 1;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 0 || full_addr != 16'h020E;
		bus_in = 16'h8888;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 1 || latch_enable != 1;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 0 || WEb != 1 || latch_enable != 0 || full_addr != 16'h8888;
		bus_in = 16'h3333;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 1;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 0 || bus_out != 16'h3333;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 1 || latch_enable != 1 || bus_dir != 0;
		@(posedge clock);
		#3 failures += OEb != 0 || full_addr != 16'h003E;
		bus_in = 16'h0DCA; //SXT (R2)
		@(posedge clock);
		#3 failures += OEb != 1 || latch_enable != 1;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 0 || latch_enable != 0 || full_addr != 16'h000E;
		bus_in = 16'h0066;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 1 || latch_enable != 0;
		bus_in = 0;
		@(posedge clock);
		#3 failures += WEb != 0 || bus_out != 16'h0000 || bus_dir != 0;
		@(posedge clock);
		#3 failures += WEb != 1 || latch_enable != 1;
		@(posedge clock);
		#3 failures += OEb != 0 || WEb != 1 || full_addr != 16'h0040 || latch_enable != 0;
		bus_in = 16'h0AC3; //DEC R3
		@(posedge clock);
		#3 failures += OEb != 1 || latch_enable != 0;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 1 || latch_enable != 1;
		@(posedge clock);
		#3 failures += OEb != 0 || latch_enable != 0 || full_addr != 16'h0042;
		bus_in = 16'h0DCA; //SXT (R2)
		@(posedge clock);
		#3 failures += OEb != 1 || latch_enable != 1;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 0 || latch_enable != 0 || full_addr != 16'h000E;
		bus_in = 16'h8866;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 1 || latch_enable != 0;
		bus_in = 0;
		@(posedge clock);
		#3 failures += WEb != 0 || bus_out != 16'hFFFF || bus_dir != 0;
		@(posedge clock);
		#3 failures += WEb != 1 || latch_enable != 1;
		@(posedge clock);
		#3 failures += OEb != 0 || WEb != 1 || full_addr != 16'h0044 || latch_enable != 0;
		bus_in = 16'h8DCA; //MFPS (R2)
		@(posedge clock);
		#3 failures += OEb != 1 || latch_enable != 1;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 0 || full_addr != 16'h000E;
		bus_in = 16'hA6B7;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 1;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 0 || bus_dir != 0 || latch_enable != 0 || full_addr != 16'h000E;
		failures += bus_out != 16'hA60A;
		@(posedge clock);
		#3 failures += latch_enable != 1;
		@(posedge clock);
		#3 failures += OEb != 0 || latch_enable != 0 || full_addr != 16'h0046;
		bus_in = 16'h8A0A; //CLRB (R2)
		@(posedge clock);
		#3 failures += OEb != 1 || latch_enable != 1;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 0 || full_addr != 16'h000E;
		bus_in = 16'h8DCA;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 1;
		bus_in = 0;
		@(posedge clock);
		#3 failures += WEb != 0 || full_addr != 16'h000E;
		failures += bus_out != 16'h8D00;
		@(posedge clock);
		#3 failures += WEb != 1 || latch_enable != 1;
		@(posedge clock);
		#3 failures += OEb != 0 || latch_enable != 0 || full_addr != 16'h0048;
		bus_in = 16'h8A82; //INCB R2
		@(posedge clock);
		#3 failures += OEb != 1 || latch_enable != 0;
		@(posedge clock);
		#3 failures += OEb != 1 || latch_enable != 1;
		@(posedge clock);
		#3 failures += OEb != 0 || full_addr != 16'h004A;
		bus_in = 16'h8A8A; //INCB (R2)
		@(posedge clock);
		#3 failures += OEb != 1 || latch_enable != 1;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 0 || full_addr != 16'h000F;
		bus_in = 16'h8DCA;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 1 || latch_enable != 0;
		bus_in = 0;
		@(posedge clock);
		#3 failures += WEb != 0 || OEb != 1 || latch_enable != 0 || bus_out != 16'h8ECA;
		@(posedge clock);
		#3 failures += WEb != 1 || OEb != 1 || latch_enable != 1;
		@(posedge clock);
		#3 failures += WEb != 1 || OEb != 0 || latch_enable != 0 || full_addr != 16'h004C;
		bus_in = 16'hf003; //MFTP
		@(posedge clock);
		#3 failures += WEb != 1 || OEb != 1 || latch_enable != 1;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 0 || full_addr != 16'h004E;
		bus_in = 16'hf004; //SVB
		@(posedge clock);
		#3 failures += WEb != 1 || OEb != 1 || latch_enable != 1;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 0 || full_addr != 16'h0050;
		bus_in = 16'h0A03; //CLR R3
		@(posedge clock);
		@(posedge clock);
		@(posedge clock);
		#3 failures += OEb != 0 || full_addr != 16'h0052;
		bus_in = 16'h0A82; //INC R2
		@(posedge clock);
		@(posedge clock);
		@(posedge clock);
		#3 failures += OEb != 0 || full_addr != 16'h0054;
		bus_in = 16'h7CCA; //IOW (R3), (R2)
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 1 || latch_enable != 1;
		@(posedge clock);
		#3 failures += OEb != 0 || latch_enable != 0 || full_addr != 16'h0010;
		bus_in = 16'h007F;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 1 || latch_enable != 0;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 1 || latch_enable != 1;
		@(posedge clock);
		#3 failures += latch_enable != 0 || OEb != 0 || WEb != 1 || full_addr != 16'h0056;
		bus_in = 16'h0A83; //INC R3
		@(posedge clock);
		@(posedge clock);
		@(posedge clock);
		#3 failures += OEb != 0 || full_addr != 16'h0058;
		bus_in = 16'h7CCA; //IOW (R3), (R2)
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 1 || latch_enable != 1;
		@(posedge clock);
		#3 failures += OEb != 0 || latch_enable != 0 || full_addr != 16'h0010;
		bus_in = 16'h002B;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 1 || latch_enable != 0;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 1 || latch_enable != 1;
		@(posedge clock);
		#3 failures += latch_enable != 0 || OEb != 0 || WEb != 1 || full_addr != 16'h005A;
		failures += PORTA_out != 7'h2B;
		bus_in = 16'h0A04; //CLR R4
		@(posedge clock);
		@(posedge clock);
		@(posedge clock);
		#3 failures += OEb != 0 || full_addr != 16'h005C;
		bus_in = 16'h7D04; //IOW (R4), R4
		@(posedge clock);
		@(posedge clock);
		#3 failures += latch_enable != 1;
		@(posedge clock);
		#3 failures += latch_enable != 0 || full_addr != 16'h005E;
		bus_in = 16'h0A83; //INC R3
		@(posedge clock);
		@(posedge clock);
		@(posedge clock);
		#3 failures += latch_enable != 0 || full_addr != 16'h0060;
		PORTA_dir = 1;
		PORTA_in = 7'h46;
		bus_in = 16'h7ACA; //IOR (R3), (R2)
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 1 || latch_enable != 1;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 0 || latch_enable != 0 || full_addr != 16'h0010;
		bus_in = 16'h9090;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 1 || latch_enable != 0;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 0 || latch_enable != 0;
		failures += bus_out != 16'h0046;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 1 || latch_enable != 1;
		@(posedge clock);
		#3 failures += OEb != 0 || WEb != 1 || latch_enable != 0 || full_addr != 16'h0062;
		bus_in = 16'h0A83; //INC R3
		@(posedge clock);
		@(posedge clock);
		@(posedge clock);
		#3 failures += latch_enable != 0 || full_addr != 16'h0064;
		PORTA_in = 0;
		bus_in = 16'h7CCA; //IOW (R3), (R2)
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 1 || latch_enable != 1;
		@(posedge clock);
		#3 failures += OEb != 0 || latch_enable != 0 || full_addr != 16'h0010;
		bus_in = 16'hFFFF;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 1 || latch_enable != 0;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 1 || WEb != 1 || latch_enable != 1;
		@(posedge clock);
		#3 failures += latch_enable != 0 || OEb != 0 || WEb != 1 || full_addr != 16'h0066;
		bus_in = 16'h0AC6; //DEC R6
		@(posedge clock);
		@(posedge clock);
		@(posedge clock);
		#3 failures += latch_enable != 0 || full_addr != 16'h0068;
		bus_in = 16'h0AC6; //DEC R6
		@(posedge clock);
		@(posedge clock);
		@(posedge clock);
		#3 failures += latch_enable != 0 || full_addr != 16'h006A;
		bus_in = 16'h0AC6; //DEC R6
		@(posedge clock);
		@(posedge clock);
		@(posedge clock);
		#3 failures += latch_enable != 0 || full_addr != 16'h006C;
		bus_in = 16'h0AC6; //DEC R6
		@(posedge clock);
		@(posedge clock);
		@(posedge clock);
		#3 failures += latch_enable != 0 || full_addr != 16'h006E;
		bus_in = 16'h0A81; //INC R1
		@(posedge clock);
		bus_in = 0;
		PORTA_in = 4;
		@(posedge clock);
		@(posedge clock);
		#3 failures += latch_enable != 1 || OEb != 1 || WEb != 1 || full_addr != 16'hFFFA;
		@(posedge clock);
		#3 failures += latch_enable != 0 || OEb != 1 || WEb != 0 || full_addr != 16'hFFFA;
		failures += bus_out != 16'h0000;
		prev_psw = bus_out;
		@(posedge clock);
		#3 failures += latch_enable != 1 || OEb != 1 || WEb != 1;
		@(posedge clock);
		#3 failures += latch_enable != 0 || OEb != 1 || WEb != 0 || full_addr != 16'hFFF8;
		failures += bus_out != 16'h0070;
		prev_pc = bus_out;
		@(posedge clock);
		#3 failures += latch_enable != 1 || OEb != 1 || WEb != 1;
		@(posedge clock);
		#3 failures += latch_enable != 0 || OEb != 0 || WEb != 1 || full_addr != 16'h0270;
		bus_in = 16'h9920;
		@(posedge clock);
		#3 failures += latch_enable != 1 || OEb != 1 || WEb != 1;
		@(posedge clock);
		#3 failures += OEb != 0 || full_addr != 16'h0272;
		bus_in = 16'h0080;
		@(posedge clock);
		#3 failures += OEb != 1 || latch_enable != 1;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 0 || full_addr != 16'h9920;
		bus_in = 16'h0AC0; //DEC R0
		@(posedge clock);
		@(posedge clock);
		@(posedge clock);
		#3 failures += latch_enable != 0 || full_addr != 16'h9922;
		bus_in = 16'h0AC0; //DEC R0
		@(posedge clock);
		@(posedge clock);
		@(posedge clock);
		#3 failures += latch_enable != 0 || full_addr != 16'h9924;
		bus_in = 16'h0002; //RTI
		@(posedge clock);
		#3 failures += OEb != 1 || latch_enable != 1;
		bus_in = 0;
		@(posedge clock);
		#3 failures += OEb != 0 || latch_enable != 0 || full_addr != 16'hFFF8;
		bus_in = prev_pc;
		@(posedge clock);
		#3 failures += OEb != 1 || latch_enable != 1;
		@(posedge clock);
		#3 failures += OEb != 0 || latch_enable != 0 || full_addr != 16'hFFFA;
		bus_in = prev_psw;
		@(posedge clock);
		#3 failures += OEb != 1 || latch_enable != 1;
		@(posedge clock);
		#3 failures += OEb != 0 || full_addr != 16'h0070;

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
		.FILENAME("pdp11.hex")
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
