module user_project_wrapper (user_clock2,
    vdd,
    vss,
    wb_clk_i,
    wb_rst_i,
    wbs_ack_o,
    wbs_cyc_i,
    wbs_stb_i,
    wbs_we_i,
    io_in,
    io_oeb,
    io_out,
    la_data_in,
    la_data_out,
    la_oenb,
    user_irq,
    wbs_adr_i,
    wbs_dat_i,
    wbs_dat_o,
    wbs_sel_i);
 input user_clock2;
 input vdd;
 input vss;
 input wb_clk_i;
 input wb_rst_i;
 output wbs_ack_o;
 input wbs_cyc_i;
 input wbs_stb_i;
 input wbs_we_i;
 input [37:0] io_in;
 output [37:0] io_oeb;
 output [37:0] io_out;
 input [63:0] la_data_in;
 output [63:0] la_data_out;
 input [63:0] la_oenb;
 output [2:0] user_irq;
 input [31:0] wbs_adr_i;
 input [31:0] wbs_dat_i;
 output [31:0] wbs_dat_o;
 input [3:0] wbs_sel_i;

 wire \ay8913_do[0] ;
 wire \ay8913_do[10] ;
 wire \ay8913_do[11] ;
 wire \ay8913_do[12] ;
 wire \ay8913_do[13] ;
 wire \ay8913_do[14] ;
 wire \ay8913_do[15] ;
 wire \ay8913_do[16] ;
 wire \ay8913_do[17] ;
 wire \ay8913_do[18] ;
 wire \ay8913_do[19] ;
 wire \ay8913_do[1] ;
 wire \ay8913_do[20] ;
 wire \ay8913_do[21] ;
 wire \ay8913_do[22] ;
 wire \ay8913_do[23] ;
 wire \ay8913_do[24] ;
 wire \ay8913_do[25] ;
 wire \ay8913_do[26] ;
 wire \ay8913_do[27] ;
 wire \ay8913_do[2] ;
 wire \ay8913_do[3] ;
 wire \ay8913_do[4] ;
 wire \ay8913_do[5] ;
 wire \ay8913_do[6] ;
 wire \ay8913_do[7] ;
 wire \ay8913_do[8] ;
 wire \ay8913_do[9] ;
 wire \blinker_do[0] ;
 wire \blinker_do[1] ;
 wire \blinker_do[2] ;
 wire \custom_settings[0] ;
 wire \custom_settings[10] ;
 wire \custom_settings[11] ;
 wire \custom_settings[12] ;
 wire \custom_settings[13] ;
 wire \custom_settings[14] ;
 wire \custom_settings[15] ;
 wire \custom_settings[16] ;
 wire \custom_settings[17] ;
 wire \custom_settings[18] ;
 wire \custom_settings[19] ;
 wire \custom_settings[1] ;
 wire \custom_settings[20] ;
 wire \custom_settings[21] ;
 wire \custom_settings[22] ;
 wire \custom_settings[23] ;
 wire \custom_settings[24] ;
 wire \custom_settings[25] ;
 wire \custom_settings[26] ;
 wire \custom_settings[27] ;
 wire \custom_settings[28] ;
 wire \custom_settings[29] ;
 wire \custom_settings[2] ;
 wire \custom_settings[30] ;
 wire \custom_settings[31] ;
 wire \custom_settings[3] ;
 wire \custom_settings[4] ;
 wire \custom_settings[5] ;
 wire \custom_settings[6] ;
 wire \custom_settings[7] ;
 wire \custom_settings[8] ;
 wire \custom_settings[9] ;
 wire hellorld_do;
 wire \mc14500_do[0] ;
 wire \mc14500_do[10] ;
 wire \mc14500_do[11] ;
 wire \mc14500_do[12] ;
 wire \mc14500_do[13] ;
 wire \mc14500_do[14] ;
 wire \mc14500_do[15] ;
 wire \mc14500_do[16] ;
 wire \mc14500_do[17] ;
 wire \mc14500_do[18] ;
 wire \mc14500_do[19] ;
 wire \mc14500_do[1] ;
 wire \mc14500_do[20] ;
 wire \mc14500_do[21] ;
 wire \mc14500_do[22] ;
 wire \mc14500_do[23] ;
 wire \mc14500_do[24] ;
 wire \mc14500_do[25] ;
 wire \mc14500_do[26] ;
 wire \mc14500_do[27] ;
 wire \mc14500_do[28] ;
 wire \mc14500_do[29] ;
 wire \mc14500_do[2] ;
 wire \mc14500_do[30] ;
 wire \mc14500_do[3] ;
 wire \mc14500_do[4] ;
 wire \mc14500_do[5] ;
 wire \mc14500_do[6] ;
 wire \mc14500_do[7] ;
 wire \mc14500_do[8] ;
 wire \mc14500_do[9] ;
 wire \mc14500_sram_addr[0] ;
 wire \mc14500_sram_addr[1] ;
 wire \mc14500_sram_addr[2] ;
 wire \mc14500_sram_addr[3] ;
 wire \mc14500_sram_addr[4] ;
 wire \mc14500_sram_addr[5] ;
 wire mc14500_sram_gwe;
 wire \mc14500_sram_in[0] ;
 wire \mc14500_sram_in[1] ;
 wire \mc14500_sram_in[2] ;
 wire \mc14500_sram_in[3] ;
 wire \mc14500_sram_in[4] ;
 wire \mc14500_sram_in[5] ;
 wire \mc14500_sram_in[6] ;
 wire \mc14500_sram_in[7] ;
 wire \qcpu_do[0] ;
 wire \qcpu_do[10] ;
 wire \qcpu_do[11] ;
 wire \qcpu_do[12] ;
 wire \qcpu_do[13] ;
 wire \qcpu_do[14] ;
 wire \qcpu_do[15] ;
 wire \qcpu_do[16] ;
 wire \qcpu_do[17] ;
 wire \qcpu_do[18] ;
 wire \qcpu_do[19] ;
 wire \qcpu_do[1] ;
 wire \qcpu_do[20] ;
 wire \qcpu_do[21] ;
 wire \qcpu_do[22] ;
 wire \qcpu_do[23] ;
 wire \qcpu_do[24] ;
 wire \qcpu_do[25] ;
 wire \qcpu_do[26] ;
 wire \qcpu_do[27] ;
 wire \qcpu_do[28] ;
 wire \qcpu_do[29] ;
 wire \qcpu_do[2] ;
 wire \qcpu_do[30] ;
 wire \qcpu_do[31] ;
 wire \qcpu_do[32] ;
 wire \qcpu_do[3] ;
 wire \qcpu_do[4] ;
 wire \qcpu_do[5] ;
 wire \qcpu_do[6] ;
 wire \qcpu_do[7] ;
 wire \qcpu_do[8] ;
 wire \qcpu_do[9] ;
 wire \qcpu_oeb[0] ;
 wire \qcpu_oeb[10] ;
 wire \qcpu_oeb[11] ;
 wire \qcpu_oeb[12] ;
 wire \qcpu_oeb[13] ;
 wire \qcpu_oeb[14] ;
 wire \qcpu_oeb[15] ;
 wire \qcpu_oeb[16] ;
 wire \qcpu_oeb[17] ;
 wire \qcpu_oeb[18] ;
 wire \qcpu_oeb[19] ;
 wire \qcpu_oeb[1] ;
 wire \qcpu_oeb[20] ;
 wire \qcpu_oeb[21] ;
 wire \qcpu_oeb[22] ;
 wire \qcpu_oeb[23] ;
 wire \qcpu_oeb[24] ;
 wire \qcpu_oeb[25] ;
 wire \qcpu_oeb[26] ;
 wire \qcpu_oeb[27] ;
 wire \qcpu_oeb[28] ;
 wire \qcpu_oeb[29] ;
 wire \qcpu_oeb[2] ;
 wire \qcpu_oeb[30] ;
 wire \qcpu_oeb[31] ;
 wire \qcpu_oeb[32] ;
 wire \qcpu_oeb[3] ;
 wire \qcpu_oeb[4] ;
 wire \qcpu_oeb[5] ;
 wire \qcpu_oeb[6] ;
 wire \qcpu_oeb[7] ;
 wire \qcpu_oeb[8] ;
 wire \qcpu_oeb[9] ;
 wire \qcpu_sram_addr[0] ;
 wire \qcpu_sram_addr[1] ;
 wire \qcpu_sram_addr[2] ;
 wire \qcpu_sram_addr[3] ;
 wire \qcpu_sram_addr[4] ;
 wire \qcpu_sram_addr[5] ;
 wire qcpu_sram_gwe;
 wire \qcpu_sram_in[0] ;
 wire \qcpu_sram_in[1] ;
 wire \qcpu_sram_in[2] ;
 wire \qcpu_sram_in[3] ;
 wire \qcpu_sram_in[4] ;
 wire \qcpu_sram_in[5] ;
 wire \qcpu_sram_in[6] ;
 wire \qcpu_sram_in[7] ;
 wire \qcpu_sram_out[0] ;
 wire \qcpu_sram_out[1] ;
 wire \qcpu_sram_out[2] ;
 wire \qcpu_sram_out[3] ;
 wire \qcpu_sram_out[4] ;
 wire \qcpu_sram_out[5] ;
 wire \qcpu_sram_out[6] ;
 wire \qcpu_sram_out[7] ;
 wire rst_ay8913;
 wire rst_blinker;
 wire rst_hellorld;
 wire rst_mc14500;
 wire rst_qcpu;
 wire rst_sid;
 wire rst_sn76489;
 wire \sid_do[0] ;
 wire \sid_do[10] ;
 wire \sid_do[11] ;
 wire \sid_do[12] ;
 wire \sid_do[13] ;
 wire \sid_do[14] ;
 wire \sid_do[15] ;
 wire \sid_do[16] ;
 wire \sid_do[17] ;
 wire \sid_do[18] ;
 wire \sid_do[19] ;
 wire \sid_do[1] ;
 wire \sid_do[20] ;
 wire \sid_do[2] ;
 wire \sid_do[3] ;
 wire \sid_do[4] ;
 wire \sid_do[5] ;
 wire \sid_do[6] ;
 wire \sid_do[7] ;
 wire \sid_do[8] ;
 wire \sid_do[9] ;
 wire sid_oeb;
 wire \sn76489_do[0] ;
 wire \sn76489_do[10] ;
 wire \sn76489_do[11] ;
 wire \sn76489_do[12] ;
 wire \sn76489_do[13] ;
 wire \sn76489_do[14] ;
 wire \sn76489_do[15] ;
 wire \sn76489_do[16] ;
 wire \sn76489_do[17] ;
 wire \sn76489_do[18] ;
 wire \sn76489_do[19] ;
 wire \sn76489_do[1] ;
 wire \sn76489_do[20] ;
 wire \sn76489_do[21] ;
 wire \sn76489_do[22] ;
 wire \sn76489_do[23] ;
 wire \sn76489_do[24] ;
 wire \sn76489_do[25] ;
 wire \sn76489_do[26] ;
 wire \sn76489_do[27] ;
 wire \sn76489_do[2] ;
 wire \sn76489_do[3] ;
 wire \sn76489_do[4] ;
 wire \sn76489_do[5] ;
 wire \sn76489_do[6] ;
 wire \sn76489_do[7] ;
 wire \sn76489_do[8] ;
 wire \sn76489_do[9] ;

 avali_logo avali_logo (.vss(vss),
    .vdd(vdd));
 wrapped_ay8913 ay8913 (.rst_n(rst_ay8913),
    .vdd(vdd),
    .vss(vss),
    .wb_clk_i(wb_clk_i),
    .custom_settings({\custom_settings[1] ,
    \custom_settings[0] }),
    .io_in_1({io_in[12],
    io_in[11],
    io_in[10],
    io_in[9],
    io_in[8],
    io_in[7],
    io_in[6],
    io_in[5]}),
    .io_in_2({io_in[20],
    io_in[19]}),
    .io_out({\ay8913_do[27] ,
    \ay8913_do[26] ,
    \ay8913_do[25] ,
    \ay8913_do[24] ,
    \ay8913_do[23] ,
    \ay8913_do[22] ,
    \ay8913_do[21] ,
    \ay8913_do[20] ,
    \ay8913_do[19] ,
    \ay8913_do[18] ,
    \ay8913_do[17] ,
    \ay8913_do[16] ,
    \ay8913_do[15] ,
    \ay8913_do[14] ,
    \ay8913_do[13] ,
    \ay8913_do[12] ,
    \ay8913_do[11] ,
    \ay8913_do[10] ,
    \ay8913_do[9] ,
    \ay8913_do[8] ,
    \ay8913_do[7] ,
    \ay8913_do[6] ,
    \ay8913_do[5] ,
    \ay8913_do[4] ,
    \ay8913_do[3] ,
    \ay8913_do[2] ,
    \ay8913_do[1] ,
    \ay8913_do[0] }));
 blinker blinker (.rst_n(rst_blinker),
    .vdd(vdd),
    .vss(vss),
    .wb_clk_i(wb_clk_i),
    .io_out({\blinker_do[2] ,
    \blinker_do[1] ,
    \blinker_do[0] }));
 hellorld hellorld (.io_out(hellorld_do),
    .rst_n(rst_hellorld),
    .vdd(vdd),
    .vss(vss),
    .wb_clk_i(wb_clk_i),
    .custom_settings({\custom_settings[11] ,
    \custom_settings[10] ,
    \custom_settings[9] ,
    \custom_settings[8] ,
    \custom_settings[7] ,
    \custom_settings[6] ,
    \custom_settings[5] ,
    \custom_settings[4] ,
    \custom_settings[3] ,
    \custom_settings[2] ,
    \custom_settings[1] ,
    \custom_settings[0] }));
 wrapped_mc14500 mc14500 (.SDI(io_in[36]),
    .clk_i(io_in[37]),
    .custom_setting(\custom_settings[0] ),
    .rst_n(rst_mc14500),
    .sram_gwe(mc14500_sram_gwe),
    .vdd(vdd),
    .vss(vss),
    .io_in({io_in[12],
    io_in[11],
    io_in[10],
    io_in[9],
    io_in[8],
    io_in[7],
    io_in[6],
    io_in[5]}),
    .io_out({\mc14500_do[30] ,
    \mc14500_do[29] ,
    \mc14500_do[28] ,
    \mc14500_do[27] ,
    \mc14500_do[26] ,
    \mc14500_do[25] ,
    \mc14500_do[24] ,
    \mc14500_do[23] ,
    \mc14500_do[22] ,
    \mc14500_do[21] ,
    \mc14500_do[20] ,
    \mc14500_do[19] ,
    \mc14500_do[18] ,
    \mc14500_do[17] ,
    \mc14500_do[16] ,
    \mc14500_do[15] ,
    \mc14500_do[14] ,
    \mc14500_do[13] ,
    \mc14500_do[12] ,
    \mc14500_do[11] ,
    \mc14500_do[10] ,
    \mc14500_do[9] ,
    \mc14500_do[8] ,
    \mc14500_do[7] ,
    \mc14500_do[6] ,
    \mc14500_do[5] ,
    \mc14500_do[4] ,
    \mc14500_do[3] ,
    \mc14500_do[2] ,
    \mc14500_do[1] ,
    \mc14500_do[0] }),
    .sram_addr({\mc14500_sram_addr[5] ,
    \mc14500_sram_addr[4] ,
    \mc14500_sram_addr[3] ,
    \mc14500_sram_addr[2] ,
    \mc14500_sram_addr[1] ,
    \mc14500_sram_addr[0] }),
    .sram_in({\mc14500_sram_in[7] ,
    \mc14500_sram_in[6] ,
    \mc14500_sram_in[5] ,
    \mc14500_sram_in[4] ,
    \mc14500_sram_in[3] ,
    \mc14500_sram_in[2] ,
    \mc14500_sram_in[1] ,
    \mc14500_sram_in[0] }),
    .sram_out({\qcpu_sram_out[7] ,
    \qcpu_sram_out[6] ,
    \qcpu_sram_out[5] ,
    \qcpu_sram_out[4] ,
    \qcpu_sram_out[3] ,
    \qcpu_sram_out[2] ,
    \qcpu_sram_out[1] ,
    \qcpu_sram_out[0] }));
 multiplexer multiplexer (.hellorld_do(hellorld_do),
    .mc14500_sram_gwe(mc14500_sram_gwe),
    .qcpu_sram_gwe(qcpu_sram_gwe),
    .rst_ay8913(rst_ay8913),
    .rst_blinker(rst_blinker),
    .rst_hellorld(rst_hellorld),
    .rst_mc14500(rst_mc14500),
    .rst_qcpu(rst_qcpu),
    .rst_sid(rst_sid),
    .rst_sn76489(rst_sn76489),
    .sid_oeb(sid_oeb),
    .vdd(vdd),
    .vss(vss),
    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wbs_ack_o(wbs_ack_o),
    .wbs_cyc_i(wbs_cyc_i),
    .wbs_stb_i(wbs_stb_i),
    .wbs_we_i(wbs_we_i),
    .ay8913_do({\ay8913_do[27] ,
    \ay8913_do[26] ,
    \ay8913_do[25] ,
    \ay8913_do[24] ,
    \ay8913_do[23] ,
    \ay8913_do[22] ,
    \ay8913_do[21] ,
    \ay8913_do[20] ,
    \ay8913_do[19] ,
    \ay8913_do[18] ,
    \ay8913_do[17] ,
    \ay8913_do[16] ,
    \ay8913_do[15] ,
    \ay8913_do[14] ,
    \ay8913_do[13] ,
    \ay8913_do[12] ,
    \ay8913_do[11] ,
    \ay8913_do[10] ,
    \ay8913_do[9] ,
    \ay8913_do[8] ,
    \ay8913_do[7] ,
    \ay8913_do[6] ,
    \ay8913_do[5] ,
    \ay8913_do[4] ,
    \ay8913_do[3] ,
    \ay8913_do[2] ,
    \ay8913_do[1] ,
    \ay8913_do[0] }),
    .blinker_do({\blinker_do[2] ,
    \blinker_do[1] ,
    \blinker_do[0] }),
    .custom_settings({\custom_settings[31] ,
    \custom_settings[30] ,
    \custom_settings[29] ,
    \custom_settings[28] ,
    \custom_settings[27] ,
    \custom_settings[26] ,
    \custom_settings[25] ,
    \custom_settings[24] ,
    \custom_settings[23] ,
    \custom_settings[22] ,
    \custom_settings[21] ,
    \custom_settings[20] ,
    \custom_settings[19] ,
    \custom_settings[18] ,
    \custom_settings[17] ,
    \custom_settings[16] ,
    \custom_settings[15] ,
    \custom_settings[14] ,
    \custom_settings[13] ,
    \custom_settings[12] ,
    \custom_settings[11] ,
    \custom_settings[10] ,
    \custom_settings[9] ,
    \custom_settings[8] ,
    \custom_settings[7] ,
    \custom_settings[6] ,
    \custom_settings[5] ,
    \custom_settings[4] ,
    \custom_settings[3] ,
    \custom_settings[2] ,
    \custom_settings[1] ,
    \custom_settings[0] }),
    .io_in({io_in[37],
    io_in[36],
    io_in[35],
    io_in[34],
    io_in[33],
    io_in[32],
    io_in[31],
    io_in[30],
    io_in[29],
    io_in[28],
    io_in[27],
    io_in[26],
    io_in[25],
    io_in[24],
    io_in[23],
    io_in[22],
    io_in[21],
    io_in[20],
    io_in[19],
    io_in[18],
    io_in[17],
    io_in[16],
    io_in[15],
    io_in[14],
    io_in[13],
    io_in[12],
    io_in[11],
    io_in[10],
    io_in[9],
    io_in[8],
    io_in[7],
    io_in[6],
    io_in[5],
    io_in[4],
    io_in[3],
    io_in[2],
    io_in[1],
    io_in[0]}),
    .io_oeb({io_oeb[37],
    io_oeb[36],
    io_oeb[35],
    io_oeb[34],
    io_oeb[33],
    io_oeb[32],
    io_oeb[31],
    io_oeb[30],
    io_oeb[29],
    io_oeb[28],
    io_oeb[27],
    io_oeb[26],
    io_oeb[25],
    io_oeb[24],
    io_oeb[23],
    io_oeb[22],
    io_oeb[21],
    io_oeb[20],
    io_oeb[19],
    io_oeb[18],
    io_oeb[17],
    io_oeb[16],
    io_oeb[15],
    io_oeb[14],
    io_oeb[13],
    io_oeb[12],
    io_oeb[11],
    io_oeb[10],
    io_oeb[9],
    io_oeb[8],
    io_oeb[7],
    io_oeb[6],
    io_oeb[5],
    io_oeb[4],
    io_oeb[3],
    io_oeb[2],
    io_oeb[1],
    io_oeb[0]}),
    .io_out({io_out[37],
    io_out[36],
    io_out[35],
    io_out[34],
    io_out[33],
    io_out[32],
    io_out[31],
    io_out[30],
    io_out[29],
    io_out[28],
    io_out[27],
    io_out[26],
    io_out[25],
    io_out[24],
    io_out[23],
    io_out[22],
    io_out[21],
    io_out[20],
    io_out[19],
    io_out[18],
    io_out[17],
    io_out[16],
    io_out[15],
    io_out[14],
    io_out[13],
    io_out[12],
    io_out[11],
    io_out[10],
    io_out[9],
    io_out[8],
    io_out[7],
    io_out[6],
    io_out[5],
    io_out[4],
    io_out[3],
    io_out[2],
    io_out[1],
    io_out[0]}),
    .irq({user_irq[2],
    user_irq[1],
    user_irq[0]}),
    .mc14500_do({\mc14500_do[30] ,
    \mc14500_do[29] ,
    \mc14500_do[28] ,
    \mc14500_do[27] ,
    \mc14500_do[26] ,
    \mc14500_do[25] ,
    \mc14500_do[24] ,
    \mc14500_do[23] ,
    \mc14500_do[22] ,
    \mc14500_do[21] ,
    \mc14500_do[20] ,
    \mc14500_do[19] ,
    \mc14500_do[18] ,
    \mc14500_do[17] ,
    \mc14500_do[16] ,
    \mc14500_do[15] ,
    \mc14500_do[14] ,
    \mc14500_do[13] ,
    \mc14500_do[12] ,
    \mc14500_do[11] ,
    \mc14500_do[10] ,
    \mc14500_do[9] ,
    \mc14500_do[8] ,
    \mc14500_do[7] ,
    \mc14500_do[6] ,
    \mc14500_do[5] ,
    \mc14500_do[4] ,
    \mc14500_do[3] ,
    \mc14500_do[2] ,
    \mc14500_do[1] ,
    \mc14500_do[0] }),
    .mc14500_sram_addr({\mc14500_sram_addr[5] ,
    \mc14500_sram_addr[4] ,
    \mc14500_sram_addr[3] ,
    \mc14500_sram_addr[2] ,
    \mc14500_sram_addr[1] ,
    \mc14500_sram_addr[0] }),
    .mc14500_sram_in({\mc14500_sram_in[7] ,
    \mc14500_sram_in[6] ,
    \mc14500_sram_in[5] ,
    \mc14500_sram_in[4] ,
    \mc14500_sram_in[3] ,
    \mc14500_sram_in[2] ,
    \mc14500_sram_in[1] ,
    \mc14500_sram_in[0] }),
    .qcpu_do({\qcpu_do[32] ,
    \qcpu_do[31] ,
    \qcpu_do[30] ,
    \qcpu_do[29] ,
    \qcpu_do[28] ,
    \qcpu_do[27] ,
    \qcpu_do[26] ,
    \qcpu_do[25] ,
    \qcpu_do[24] ,
    \qcpu_do[23] ,
    \qcpu_do[22] ,
    \qcpu_do[21] ,
    \qcpu_do[20] ,
    \qcpu_do[19] ,
    \qcpu_do[18] ,
    \qcpu_do[17] ,
    \qcpu_do[16] ,
    \qcpu_do[15] ,
    \qcpu_do[14] ,
    \qcpu_do[13] ,
    \qcpu_do[12] ,
    \qcpu_do[11] ,
    \qcpu_do[10] ,
    \qcpu_do[9] ,
    \qcpu_do[8] ,
    \qcpu_do[7] ,
    \qcpu_do[6] ,
    \qcpu_do[5] ,
    \qcpu_do[4] ,
    \qcpu_do[3] ,
    \qcpu_do[2] ,
    \qcpu_do[1] ,
    \qcpu_do[0] }),
    .qcpu_oeb({\qcpu_oeb[32] ,
    \qcpu_oeb[31] ,
    \qcpu_oeb[30] ,
    \qcpu_oeb[29] ,
    \qcpu_oeb[28] ,
    \qcpu_oeb[27] ,
    \qcpu_oeb[26] ,
    \qcpu_oeb[25] ,
    \qcpu_oeb[24] ,
    \qcpu_oeb[23] ,
    \qcpu_oeb[22] ,
    \qcpu_oeb[21] ,
    \qcpu_oeb[20] ,
    \qcpu_oeb[19] ,
    \qcpu_oeb[18] ,
    \qcpu_oeb[17] ,
    \qcpu_oeb[16] ,
    \qcpu_oeb[15] ,
    \qcpu_oeb[14] ,
    \qcpu_oeb[13] ,
    \qcpu_oeb[12] ,
    \qcpu_oeb[11] ,
    \qcpu_oeb[10] ,
    \qcpu_oeb[9] ,
    \qcpu_oeb[8] ,
    \qcpu_oeb[7] ,
    \qcpu_oeb[6] ,
    \qcpu_oeb[5] ,
    \qcpu_oeb[4] ,
    \qcpu_oeb[3] ,
    \qcpu_oeb[2] ,
    \qcpu_oeb[1] ,
    \qcpu_oeb[0] }),
    .qcpu_sram_addr({\qcpu_sram_addr[5] ,
    \qcpu_sram_addr[4] ,
    \qcpu_sram_addr[3] ,
    \qcpu_sram_addr[2] ,
    \qcpu_sram_addr[1] ,
    \qcpu_sram_addr[0] }),
    .qcpu_sram_in({\qcpu_sram_in[7] ,
    \qcpu_sram_in[6] ,
    \qcpu_sram_in[5] ,
    \qcpu_sram_in[4] ,
    \qcpu_sram_in[3] ,
    \qcpu_sram_in[2] ,
    \qcpu_sram_in[1] ,
    \qcpu_sram_in[0] }),
    .qcpu_sram_out({\qcpu_sram_out[7] ,
    \qcpu_sram_out[6] ,
    \qcpu_sram_out[5] ,
    \qcpu_sram_out[4] ,
    \qcpu_sram_out[3] ,
    \qcpu_sram_out[2] ,
    \qcpu_sram_out[1] ,
    \qcpu_sram_out[0] }),
    .sid_do({\sid_do[20] ,
    \sid_do[19] ,
    \sid_do[18] ,
    \sid_do[17] ,
    \sid_do[16] ,
    \sid_do[15] ,
    \sid_do[14] ,
    \sid_do[13] ,
    \sid_do[12] ,
    \sid_do[11] ,
    \sid_do[10] ,
    \sid_do[9] ,
    \sid_do[8] ,
    \sid_do[7] ,
    \sid_do[6] ,
    \sid_do[5] ,
    \sid_do[4] ,
    \sid_do[3] ,
    \sid_do[2] ,
    \sid_do[1] ,
    \sid_do[0] }),
    .sn76489_do({\sn76489_do[27] ,
    \sn76489_do[26] ,
    \sn76489_do[25] ,
    \sn76489_do[24] ,
    \sn76489_do[23] ,
    \sn76489_do[22] ,
    \sn76489_do[21] ,
    \sn76489_do[20] ,
    \sn76489_do[19] ,
    \sn76489_do[18] ,
    \sn76489_do[17] ,
    \sn76489_do[16] ,
    \sn76489_do[15] ,
    \sn76489_do[14] ,
    \sn76489_do[13] ,
    \sn76489_do[12] ,
    \sn76489_do[11] ,
    \sn76489_do[10] ,
    \sn76489_do[9] ,
    \sn76489_do[8] ,
    \sn76489_do[7] ,
    \sn76489_do[6] ,
    \sn76489_do[5] ,
    \sn76489_do[4] ,
    \sn76489_do[3] ,
    \sn76489_do[2] ,
    \sn76489_do[1] ,
    \sn76489_do[0] }),
    .wbs_adr_i({wbs_adr_i[31],
    wbs_adr_i[30],
    wbs_adr_i[29],
    wbs_adr_i[28],
    wbs_adr_i[27],
    wbs_adr_i[26],
    wbs_adr_i[25],
    wbs_adr_i[24],
    wbs_adr_i[23],
    wbs_adr_i[22],
    wbs_adr_i[21],
    wbs_adr_i[20],
    wbs_adr_i[19],
    wbs_adr_i[18],
    wbs_adr_i[17],
    wbs_adr_i[16],
    wbs_adr_i[15],
    wbs_adr_i[14],
    wbs_adr_i[13],
    wbs_adr_i[12],
    wbs_adr_i[11],
    wbs_adr_i[10],
    wbs_adr_i[9],
    wbs_adr_i[8],
    wbs_adr_i[7],
    wbs_adr_i[6],
    wbs_adr_i[5],
    wbs_adr_i[4],
    wbs_adr_i[3],
    wbs_adr_i[2],
    wbs_adr_i[1],
    wbs_adr_i[0]}),
    .wbs_dat_i({wbs_dat_i[31],
    wbs_dat_i[30],
    wbs_dat_i[29],
    wbs_dat_i[28],
    wbs_dat_i[27],
    wbs_dat_i[26],
    wbs_dat_i[25],
    wbs_dat_i[24],
    wbs_dat_i[23],
    wbs_dat_i[22],
    wbs_dat_i[21],
    wbs_dat_i[20],
    wbs_dat_i[19],
    wbs_dat_i[18],
    wbs_dat_i[17],
    wbs_dat_i[16],
    wbs_dat_i[15],
    wbs_dat_i[14],
    wbs_dat_i[13],
    wbs_dat_i[12],
    wbs_dat_i[11],
    wbs_dat_i[10],
    wbs_dat_i[9],
    wbs_dat_i[8],
    wbs_dat_i[7],
    wbs_dat_i[6],
    wbs_dat_i[5],
    wbs_dat_i[4],
    wbs_dat_i[3],
    wbs_dat_i[2],
    wbs_dat_i[1],
    wbs_dat_i[0]}),
    .wbs_dat_o({wbs_dat_o[31],
    wbs_dat_o[30],
    wbs_dat_o[29],
    wbs_dat_o[28],
    wbs_dat_o[27],
    wbs_dat_o[26],
    wbs_dat_o[25],
    wbs_dat_o[24],
    wbs_dat_o[23],
    wbs_dat_o[22],
    wbs_dat_o[21],
    wbs_dat_o[20],
    wbs_dat_o[19],
    wbs_dat_o[18],
    wbs_dat_o[17],
    wbs_dat_o[16],
    wbs_dat_o[15],
    wbs_dat_o[14],
    wbs_dat_o[13],
    wbs_dat_o[12],
    wbs_dat_o[11],
    wbs_dat_o[10],
    wbs_dat_o[9],
    wbs_dat_o[8],
    wbs_dat_o[7],
    wbs_dat_o[6],
    wbs_dat_o[5],
    wbs_dat_o[4],
    wbs_dat_o[3],
    wbs_dat_o[2],
    wbs_dat_o[1],
    wbs_dat_o[0]}));
 wrapped_sid sid (.io_oeb(sid_oeb),
    .rst_n(rst_sid),
    .vdd(vdd),
    .vss(vss),
    .wb_clk_i(wb_clk_i),
    .io_in({io_in[37],
    io_in[36],
    io_in[35],
    io_in[34],
    io_in[33],
    io_in[32],
    io_in[31],
    io_in[30],
    io_in[29],
    io_in[28],
    io_in[27],
    io_in[26],
    io_in[25],
    io_in[24],
    io_in[23],
    io_in[22],
    io_in[21],
    io_in[20],
    io_in[19],
    io_in[18],
    io_in[17],
    io_in[16],
    io_in[15],
    io_in[14],
    io_in[13],
    io_in[12],
    io_in[11],
    io_in[10],
    io_in[9],
    io_in[8],
    io_in[7],
    io_in[6],
    io_in[5]}),
    .io_out({\sid_do[20] ,
    \sid_do[19] ,
    \sid_do[18] ,
    \sid_do[17] ,
    \sid_do[16] ,
    \sid_do[15] ,
    \sid_do[14] ,
    \sid_do[13] ,
    \sid_do[12] ,
    \sid_do[11] ,
    \sid_do[10] ,
    \sid_do[9] ,
    \sid_do[8] ,
    \sid_do[7] ,
    \sid_do[6] ,
    \sid_do[5] ,
    \sid_do[4] ,
    \sid_do[3] ,
    \sid_do[2] ,
    \sid_do[1] ,
    \sid_do[0] }));
 wrapped_qcpu wrapped_qcpu (.rst_n(rst_qcpu),
    .sram_gwe(qcpu_sram_gwe),
    .vdd(vdd),
    .vss(vss),
    .wb_clk_i(wb_clk_i),
    .custom_settings({\custom_settings[31] ,
    \custom_settings[30] ,
    \custom_settings[29] ,
    \custom_settings[28] ,
    \custom_settings[27] ,
    \custom_settings[26] ,
    \custom_settings[25] ,
    \custom_settings[24] ,
    \custom_settings[23] ,
    \custom_settings[22] ,
    \custom_settings[21] ,
    \custom_settings[20] ,
    \custom_settings[19] ,
    \custom_settings[18] ,
    \custom_settings[17] ,
    \custom_settings[16] ,
    \custom_settings[15] ,
    \custom_settings[14] ,
    \custom_settings[13] ,
    \custom_settings[12] ,
    \custom_settings[11] ,
    \custom_settings[10] ,
    \custom_settings[9] ,
    \custom_settings[8] ,
    \custom_settings[7] ,
    \custom_settings[6] ,
    \custom_settings[5] ,
    \custom_settings[4] ,
    \custom_settings[3] ,
    \custom_settings[2] ,
    \custom_settings[1] ,
    \custom_settings[0] }),
    .io_in({io_in[37],
    io_in[36],
    io_in[35],
    io_in[34],
    io_in[33],
    io_in[32],
    io_in[31],
    io_in[30],
    io_in[29],
    io_in[28],
    io_in[27],
    io_in[26],
    io_in[25],
    io_in[24],
    io_in[23],
    io_in[22],
    io_in[21],
    io_in[20],
    io_in[19],
    io_in[18],
    io_in[17],
    io_in[16],
    io_in[15],
    io_in[14],
    io_in[13],
    io_in[12],
    io_in[11],
    io_in[10],
    io_in[9],
    io_in[8],
    io_in[7],
    io_in[6],
    io_in[5]}),
    .io_oeb({\qcpu_oeb[32] ,
    \qcpu_oeb[31] ,
    \qcpu_oeb[30] ,
    \qcpu_oeb[29] ,
    \qcpu_oeb[28] ,
    \qcpu_oeb[27] ,
    \qcpu_oeb[26] ,
    \qcpu_oeb[25] ,
    \qcpu_oeb[24] ,
    \qcpu_oeb[23] ,
    \qcpu_oeb[22] ,
    \qcpu_oeb[21] ,
    \qcpu_oeb[20] ,
    \qcpu_oeb[19] ,
    \qcpu_oeb[18] ,
    \qcpu_oeb[17] ,
    \qcpu_oeb[16] ,
    \qcpu_oeb[15] ,
    \qcpu_oeb[14] ,
    \qcpu_oeb[13] ,
    \qcpu_oeb[12] ,
    \qcpu_oeb[11] ,
    \qcpu_oeb[10] ,
    \qcpu_oeb[9] ,
    \qcpu_oeb[8] ,
    \qcpu_oeb[7] ,
    \qcpu_oeb[6] ,
    \qcpu_oeb[5] ,
    \qcpu_oeb[4] ,
    \qcpu_oeb[3] ,
    \qcpu_oeb[2] ,
    \qcpu_oeb[1] ,
    \qcpu_oeb[0] }),
    .io_out({\qcpu_do[32] ,
    \qcpu_do[31] ,
    \qcpu_do[30] ,
    \qcpu_do[29] ,
    \qcpu_do[28] ,
    \qcpu_do[27] ,
    \qcpu_do[26] ,
    \qcpu_do[25] ,
    \qcpu_do[24] ,
    \qcpu_do[23] ,
    \qcpu_do[22] ,
    \qcpu_do[21] ,
    \qcpu_do[20] ,
    \qcpu_do[19] ,
    \qcpu_do[18] ,
    \qcpu_do[17] ,
    \qcpu_do[16] ,
    \qcpu_do[15] ,
    \qcpu_do[14] ,
    \qcpu_do[13] ,
    \qcpu_do[12] ,
    \qcpu_do[11] ,
    \qcpu_do[10] ,
    \qcpu_do[9] ,
    \qcpu_do[8] ,
    \qcpu_do[7] ,
    \qcpu_do[6] ,
    \qcpu_do[5] ,
    \qcpu_do[4] ,
    \qcpu_do[3] ,
    \qcpu_do[2] ,
    \qcpu_do[1] ,
    \qcpu_do[0] }),
    .sram_addr({\qcpu_sram_addr[5] ,
    \qcpu_sram_addr[4] ,
    \qcpu_sram_addr[3] ,
    \qcpu_sram_addr[2] ,
    \qcpu_sram_addr[1] ,
    \qcpu_sram_addr[0] }),
    .sram_in({\qcpu_sram_in[7] ,
    \qcpu_sram_in[6] ,
    \qcpu_sram_in[5] ,
    \qcpu_sram_in[4] ,
    \qcpu_sram_in[3] ,
    \qcpu_sram_in[2] ,
    \qcpu_sram_in[1] ,
    \qcpu_sram_in[0] }),
    .sram_out({\qcpu_sram_out[7] ,
    \qcpu_sram_out[6] ,
    \qcpu_sram_out[5] ,
    \qcpu_sram_out[4] ,
    \qcpu_sram_out[3] ,
    \qcpu_sram_out[2] ,
    \qcpu_sram_out[1] ,
    \qcpu_sram_out[0] }));
 wrapped_sn76489 wrapped_sn76489 (.io_in_2(io_in[19]),
    .rst_n(rst_sn76489),
    .vdd(vdd),
    .vss(vss),
    .wb_clk_i(wb_clk_i),
    .custom_settings({\custom_settings[1] ,
    \custom_settings[0] }),
    .io_in_1({io_in[12],
    io_in[11],
    io_in[10],
    io_in[9],
    io_in[8],
    io_in[7],
    io_in[6],
    io_in[5]}),
    .io_out({\sn76489_do[27] ,
    \sn76489_do[26] ,
    \sn76489_do[25] ,
    \sn76489_do[24] ,
    \sn76489_do[23] ,
    \sn76489_do[22] ,
    \sn76489_do[21] ,
    \sn76489_do[20] ,
    \sn76489_do[19] ,
    \sn76489_do[18] ,
    \sn76489_do[17] ,
    \sn76489_do[16] ,
    \sn76489_do[15] ,
    \sn76489_do[14] ,
    \sn76489_do[13] ,
    \sn76489_do[12] ,
    \sn76489_do[11] ,
    \sn76489_do[10] ,
    \sn76489_do[9] ,
    \sn76489_do[8] ,
    \sn76489_do[7] ,
    \sn76489_do[6] ,
    \sn76489_do[5] ,
    \sn76489_do[4] ,
    \sn76489_do[3] ,
    \sn76489_do[2] ,
    \sn76489_do[1] ,
    \sn76489_do[0] }));
endmodule
