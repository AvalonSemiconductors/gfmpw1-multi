// SPDX-FileCopyrightText: 2020 Efabless Corporation
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
/*
 *-------------------------------------------------------------
 *
 * user_project_wrapper
 *
 * This wrapper enumerates all of the pins available to the
 * user for the user project.
 *
 * An example user project is provided in this wrapper.  The
 * example should be removed and replaced with the actual
 * user project.
 *
 *-------------------------------------------------------------
 */

module user_project_wrapper #(
    parameter BITS = 32
) (
`ifdef USE_POWER_PINS
    inout vdd,		// User area 5.0V supply
    inout vss,		// User area ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [63:0] la_data_in,
    output [63:0] la_data_out,
    input  [63:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // Independent clock (on independent integer divider)
    input   user_clock2,

    // User maskable interrupt signals
    output [2:0] user_irq
);

/*--------------------------------------*/
/* User projects are instantiated here   */
/*--------------------------------------*/

wire rst_blinker;
wire [2:0] blinker_do;

wire rst_sid;
wire [20:0] sid_do;
wire sid_oeb;

wire rst_sn76489;
wire [27:0] sn76489_do;

wire rst_qcpu;
wire [32:0] qcpu_do;
wire [32:0] qcpu_oeb;
wire [5:0] qcpu_sram_addr;
wire [7:0] qcpu_sram_in;
wire [7:0] qcpu_sram_out;
wire qcpu_sram_gwe;

wire [31:0] custom_settings;

multiplexer multiplexer (
`ifdef USE_POWER_PINS
	.vdd(vdd),	// User area 1 1.8V power
	.vss(vss),	// User area 1 digital ground
`endif

    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),

    // MGMT SoC Wishbone Slave

    .wbs_cyc_i(wbs_cyc_i),
    .wbs_stb_i(wbs_stb_i),
    .wbs_we_i(wbs_we_i),
    .wbs_adr_i(wbs_adr_i),
    .wbs_dat_i(wbs_dat_i),
    .wbs_ack_o(wbs_ack_o),
    .wbs_dat_o(wbs_dat_o),

    // IO Pads

    .io_in (io_in),
    .io_out(io_out),
    .io_oeb(io_oeb),

    // IRQ
    .irq(user_irq),
    
    .rst_blinker(rst_blinker),
    .blinker_do(blinker_do),

    .rst_sid(rst_sid),
    .sid_do(sid_do),
    .sid_oeb(sid_oeb),

    .rst_sn76489(rst_sn76489),
    .sn76489_do(sn76489_do),
    
    .rst_qcpu(rst_qcpu),
    .qcpu_do(qcpu_do),
    .qcpu_oeb(qcpu_oeb),
    .qcpu_sram_addr(qcpu_sram_addr),
    .qcpu_sram_in(qcpu_sram_in),
    .qcpu_sram_out(qcpu_sram_out),
    .qcpu_sram_gwe(qcpu_sram_gwe),

    .custom_settings(custom_settings)
);

wrapped_sid sid(
`ifdef USE_POWER_PINS
	.vdd(vdd),	// User area 1 1.8V power
	.vss(vss),	// User area 1 digital ground
`endif
	.wb_clk_i(wb_clk_i),
    .rst_n(rst_sid),
	.io_in(io_in[37:5]),
	.io_out(sid_do),
	.io_oeb(sid_oeb)
);

blinker blinker(
`ifdef USE_POWER_PINS
	.vdd(vdd),	// User area 1 1.8V power
	.vss(vss),	// User area 1 digital ground
`endif
    .wb_clk_i(wb_clk_i),
    .rst_n(rst_blinker),
    .io_out(blinker_do)
);

wrapped_sn76489 wrapped_sn76489(
`ifdef USE_POWER_PINS
	.vdd(vdd),	// User area 1 1.8V power
	.vss(vss),	// User area 1 digital ground
`endif
    .wb_clk_i(wb_clk_i),
    .rst_n(rst_sn76489),
    .io_in_1(io_in[12:5]),
    .io_in_2(io_in[19]),
    .io_out(sn76489_do),
    .custom_settings(custom_settings[1:0])
);

avali_logo avali_logo(
`ifdef USE_POWER_PINS
	.vdd(vdd),	// User area 1 1.8V power
	.vss(vss)	// User area 1 digital ground
`endif
);

wrapped_qcpu wrapped_qcpu(
`ifdef USE_POWER_PINS
	.vdd(vdd),	// User area 1 1.8V power
	.vss(vss),	// User area 1 digital ground
`endif
    .wb_clk_i(wb_clk_i),
    .rst_n(rst_qcpu),
    .io_in(io_in[37:5]),
    .io_out(qcpu_do),
    .io_oeb(qcpu_oeb),
    .custom_settings(custom_settings),
    .sram_addr(qcpu_sram_addr),
    .sram_in(qcpu_sram_in),
    .sram_out(qcpu_sram_out),
    .sram_gwe(qcpu_sram_gwe)
);

endmodule	// user_project_wrapper

`default_nettype wire