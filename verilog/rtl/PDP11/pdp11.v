`default_nettype none

module pdp11(
	input clk,
	input rst_n,
	
	output [15:0] bus_out,
	input [15:0] bus_in,
	output bus_oeb,
	output latch_enable,

	output OEb,
	output WEb,

	input enable_map_psw,

	output is_halted,

	input [7:0] int_reqs,
	output [7:0] int_ack,

	output [7:0] io_addr,
	output [15:0] io_out,
	input [15:0] io_in,
	output io_wen,

	input illegal_trap_enable,
	input [14:0] start_addr,
	input trace_trap_enable
);

wire [2:0] highest_int_req = int_reqs[7] ? 3'b111 : (int_reqs[6] ? 3'b110 : (int_reqs[5] ? 3'b101 : (int_reqs[4] ? 3'b100 : (int_reqs[3] ? 3'b011 : (int_reqs[2] ? 3'b010 : (int_reqs[1] ? 3'b001 : 3'b000))))));
reg [7:0] int_ack_num;
always @(*) begin
	case(handling_int)
		0: int_ack_num = 8'h01;
		1: int_ack_num = 8'h02;
		2: int_ack_num = 8'h04;
		3: int_ack_num = 8'h08;
		4: int_ack_num = 8'h10;
		5: int_ack_num = 8'h20;
		6: int_ack_num = 8'h40;
		7: int_ack_num = 8'h80;
	endcase
end
assign int_ack = cycle == INT3 || cycle == INT4 ? int_ack_num : 8'h00;

reg [15:0] regs [7:0];
reg [7:0] PSW;

localparam FETCH1 = 0;
localparam FETCH2 = 1;
localparam FETCH3 = 2;
localparam EXEC1 = 3;
localparam MEM1 = 4; //READ
localparam ARG2 = 5;
localparam MEM2 = 6; //WRITE
localparam WAIT = 7;
localparam JMP1 = 8;
localparam JSR1 = 9;
localparam RTS1 = 10;
localparam RTI1 = 11;
localparam INT1 = 12;
localparam INT2 = 13;
localparam INT3 = 14;
localparam INT4 = 15;
localparam MUL = 16;
localparam DIV1 = 17;
localparam DIV2 = 18;
reg [4:0] cycle;
reg [2:0] addr_mode;
wire is_defered_mode = addr_mode == 3 || addr_mode == 5 || addr_mode == 7;
reg byte_op;
reg [15:0] mem_targ;
reg [15:0] mem_io;
reg [1:0] warmup;
reg waiting;
reg halted;
assign is_halted = halted || waiting;
reg [15:0] jmp_targ;
reg last_trace_trap;

reg [10:0] IVB;
reg [2:0] handling_int;
wire [15:0] vector_addr = {IVB, handling_int, cycle == INT4, 1'b0};

reg [15:0] insin;
wire [15:0] instruction = cycle == FETCH1 ? bus_in : insin;

assign bus_oeb = !(latch_enable_pre || (!WEb)) || (!rst_n);
wire [15:0] mem_read_val = current_addr == 16'hFFFE && enable_map_psw ? {8'h00, PSW} : bus_in;

wire is_instr_fetch_cycle = (cycle == FETCH1 || cycle == FETCH2 || cycle == FETCH3);
wire is_data_fetch_cycle = cycle == MEM1;
reg [15:0] requested_addr;
always @(*) begin
	case(cycle)
		default: requested_addr = current_addr;
		FETCH1: requested_addr = regs[7];
		FETCH2: requested_addr = regs[7];
		FETCH3: requested_addr = regs[7];
		MEM1: requested_addr = mem_targ;
		JMP1: requested_addr = is_defered_mode ? jmp_targ : current_addr;
		JSR1: requested_addr = regs[6];
		RTS1: requested_addr = regs[6];
		RTI1: requested_addr = regs[6];
		INT1: requested_addr = regs[6];
		INT2: requested_addr = regs[6];
		INT3: requested_addr = is_trap ? trap_targ : vector_addr;
		INT4: requested_addr = is_trap ? trap_targ + 2 : vector_addr;
	endcase
end

reg [15:0] current_addr;
reg [15:0] source_index;
reg [15:0] dest_index;
reg has_second_arg;

wire latch_enable_pre = (requested_addr != current_addr) && rst_n && (warmup == 0);
assign latch_enable = latch_enable_pre && clk;

assign bus_out = requested_addr != current_addr ? requested_addr : (cycle == INT1 ? PSW : (cycle == INT2 ? regs[7] : mem_io));
assign WEb = !((cycle == MEM2 || cycle == JSR1 || cycle == INT1 || cycle == INT2) && requested_addr == current_addr);
assign OEb = !((is_instr_fetch_cycle || is_data_fetch_cycle || (cycle == JMP1 && is_defered_mode) || cycle == RTS1 || cycle == RTI1 || cycle == INT3 || cycle == INT4) && requested_addr == current_addr) || (!rst_n) || (!WEb);

/*
 * Instruction decode
 */
wire is_HALT = instruction == 16'h0000;
wire is_WAIT = instruction == 16'h0001;
wire is_RTI = instruction == 16'h0002;
wire is_BPT = instruction == 16'h0003;
wire is_IOT = instruction == 16'h0004;
wire is_RESET = instruction == 16'h0005;
wire is_RTT = instruction == 16'h0006;
wire is_CCC = instruction[15:4] == 12'h00A;
wire is_SCC = instruction[15:4] == 12'h00B;
wire is_TRAP = instruction[15:8] == 8'h89;
wire is_EMT = instruction[15:8] == 8'h88;
wire is_MARK = instruction[15:6] == 10'h034;
wire is_RTS = instruction[15:3] == 13'h0010;
wire is_JSR = instruction[15:9] == 7'h04;
wire is_BRANCH = instruction[15:8] == 8'h01
					|| instruction[15:9] == 7'h01
					|| instruction[15:9] == 7'h02
					|| instruction[15:9] == 7'h03
					|| instruction[15:9] == 7'h40
					|| instruction[15:9] == 7'h41
					|| instruction[15:9] == 7'h42
					|| instruction[15:9] == 7'h43
					|| instruction[15:9] == 7'h3F;
wire is_SOB = instruction[15:9] == 7'h3F;
wire [2:0] SOB_reg = instruction[8:6];
wire [15:0] SOB_reg_m1 = regs[SOB_reg] - 1;
wire [2:0] linkage_reg = instruction[8:6];
wire [2:0] rts_reg = instruction[2:0];

wire is_MOV = instruction[14:12] == 3'h1;
wire is_CMP = instruction[14:12] == 3'h2;
wire is_BIT = instruction[14:12] == 3'h3;
wire is_BIC = instruction[14:12] == 3'h4;
wire is_BIS = instruction[14:12] == 3'h5;
wire is_ADD = instruction[15:12] == 4'h6;
wire is_SUB = instruction[15:12] == 4'hE;
wire is_double_op = instruction[14:12] != 0 && !(instruction[14:12] == 3'h7) && !is_SETI && !is_SETD;

wire is_JMP = instruction[15:6] == 10'h001;
wire is_SWAB = instruction[15:6] == 10'h003;
wire is_CLR = instruction[14:6] == 9'h028;
wire is_COM = instruction[14:6] == 9'h029;
wire is_INC = instruction[14:6] == 9'h02A;
wire is_DEC = instruction[14:6] == 9'h02B;
wire is_NEG = instruction[14:6] == 9'h02C;
wire is_ADC = instruction[14:6] == 9'h02D;
wire is_SBC = instruction[14:6] == 9'h02E;
wire is_TST = instruction[14:6] == 9'h02F;
wire is_ROR = instruction[14:6] == 9'h030;
wire is_ROL = instruction[14:6] == 9'h031;
wire is_ASR = instruction[14:6] == 9'h032;
wire is_ASL = instruction[14:6] == 9'h033;
wire is_MTPS = instruction[15:6] == 10'h234;
wire is_SXT = instruction[15:6] == 10'h037;
wire is_MFPS = instruction[15:6] == 10'h237;
wire is_single_op = (is_JMP || is_SWAB || (instruction[14:6] >= 9'h028 && instruction[14:6] <= 9'h037)) && instruction[15:6] != 10'h034 && !is_SETD && !is_SETI && !is_MFTP;
wire is_MUL = instruction[15:9] == 7'h38;
wire is_DIV = instruction[15:9] == 7'h39;
wire is_ASH = instruction[15:9] == 7'h3A;
wire is_ASHC = instruction[15:9] == 7'h3B;
wire is_XOR = instruction[15:9] == 7'h3C;
wire is_IOR = instruction[15:9] == 7'h3D;
wire is_IOW = instruction[15:9] == 7'h3E;
wire is_special = is_MUL || is_DIV || is_ASH || is_ASHC || is_XOR || is_IOR || is_IOW;
wire [2:0] special_extra_reg = instruction[8:6];
wire is_MFTP = instruction == 16'hf003;
wire is_SVB = instruction == 16'hf004;
wire is_SETD = instruction == 16'hf009;
wire is_SETI = instruction == 16'hf002;
wire is_TRACE = instruction == 16'hf00A;
assign io_addr = regs[special_extra_reg][7:0];
assign io_out = instr_arg_1;
assign io_wen = is_IOW && cycle == EXEC1;

wire is_byte_instr = instruction[15] && !(is_ADD || is_SUB);

wire [2:0] br_idx = {instruction[15], instruction[10:9]};
reg should_branch;
always @(*) begin
	case(br_idx)
		default: should_branch = 1'b1;
		1: should_branch = PSW[2];
		2: should_branch = PSW[3] ^ PSW[1];
		3: should_branch = PSW[2] | (PSW[3] ^ PSW[1]);
		4: should_branch = PSW[3];
		5: should_branch = PSW[0] | PSW[2];
		6: should_branch = PSW[1];
		7: should_branch = PSW[0];
	endcase
end
wire [15:0] branch_targ = is_SOB ? regs[7] - {8'h00, 1'b0, instruction[5:0], 1'b0} : regs[7] + {instruction[7], instruction[7], instruction[7], instruction[7], instruction[7], instruction[7], instruction[7], instruction[7:0], 1'b0};
reg [7:0] trap_targ;
reg is_trap;

wire [4:0] collission = (is_HALT + is_WAIT + is_RTI + is_BPT + is_IOT + is_RESET + is_RTT + is_CCC + is_SCC + is_TRAP + is_MARK + is_RTS + is_JSR + is_BRANCH + is_MOV + is_CMP  + is_BIT + is_BIC + is_BIS
	+ is_ADD + is_SUB + is_JMP + is_SWAB + is_CLR + is_COM + is_INC + is_DEC + is_NEG + is_ADC + is_SBC + is_TST + is_ROR + is_ROL + is_ASR + is_ASL + is_MTPS + is_SXT + is_MFPS
	+ is_MUL + is_DIV + is_ASH + is_ASHC + is_XOR + is_MFTP + is_SETD + is_SETI + is_SVB + is_IOR + is_IOW + is_EMT + is_TRACE
);

`ifdef SIM
wire [15:0] R0 = regs[0];
wire [15:0] R1 = regs[1];
wire [15:0] R2 = regs[2];
wire [15:0] R3 = regs[3];
wire [15:0] R4 = regs[4];
wire [15:0] R5 = regs[5];
wire [15:0] SP = regs[6];
wire [15:0] PC = regs[7];

wire is_colliding = collission > 1;
`endif

wire [2:0] src_mode = is_single_op || is_special || is_JMP || is_JSR ? instruction[5:3] : instruction[11:9];
wire [2:0] src_reg = is_single_op || is_special || is_JMP || is_JSR ? instruction[2:0] : instruction[8:6];
wire [15:0] decr_reg = is_byte_instr && src_mode != 5 && src_reg != 7 ? regs[src_reg] - 1 : regs[src_reg] - 2;
wire [15:0] incr_reg = is_byte_instr && src_mode != 3 && src_reg != 7 ? regs[src_reg] + 1 : regs[src_reg] + 2;
wire [2:0] dest_mode = is_single_op || is_special ? src_mode : instruction[5:3];
wire [2:0] dest_reg = is_single_op || is_special ? src_reg : instruction[2:0];
wire [15:0] dest_decr_reg = is_byte_instr && dest_mode != 5 && dest_reg != 7 ? regs[dest_reg] - 1 : regs[dest_reg] - 2;
wire [15:0] dest_incr_reg = is_byte_instr && dest_mode != 3 && dest_reg != 7 ? regs[dest_reg] + 1 : regs[dest_reg] + 2;

reg [15:0] instr_arg_1;
reg [15:0] instr_arg_2;
wire [15:0] instr_result_inc = instr_arg_1 + 1;
wire [15:0] instr_result_dec = instr_arg_1 - 1;
wire [15:0] instr_result_neg = ~instr_arg_1 + 1;
wire [15:0] instr_result_adc = instr_arg_1 + {15'h0000, PSW[0]};
wire [15:0] instr_result_sbc = instr_arg_1 - {15'h0000, PSW[0]};
wire [16:0] instr_result_cmp = instr_arg_1 - instr_arg_2;
wire [16:0] instr_result_add = instr_arg_1 + instr_arg_2;
wire [16:0] instr_result_sub = instr_arg_2 - instr_arg_1;
wire [15:0] instr_result_AND = instr_arg_1 & instr_arg_2;
wire [15:0] instr_result_XOR = instr_arg_1 ^ regs[special_extra_reg];
wire [15:0] instr_result_BIC = (~instr_arg_1) & instr_arg_2;
wire [15:0] instr_result_BIS = instr_arg_1 | instr_arg_2;

wire [15:0] muli1 = instr_arg_1;
wire [15:0] muli2 = regs[special_extra_reg];
wire mul_s1 = muli1[15];
wire mul_s2 = muli2[15];
wire mul_s3 = mul_s1 ^ mul_s2;
wire [15:0] muli1_us = mul_s1 ? (~muli1) + 1 : muli1;
wire [15:0] muli2_us = mul_s2 ? (~muli2) + 1 : muli2;
wire [31:0] vlsiffra_res;
wire [31:0] mul_res = mul_s3 ? (~vlsiffra_res) + 1 : vlsiffra_res;
multiplier_2 multiplier(
	.clk(clk),
	.rst(!rst_n),
	.a(muli1_us),
	.b(muli2_us),
	.o(vlsiffra_res)
);

wire [31:0] divi1 = {regs[special_extra_reg], regs[special_extra_reg | 1]};
wire [15:0] divi2 = instr_arg_1;
wire div_s1 = divi1[31];
wire div_s2 = divi2[15];
wire div_s3 = div_s1 ^ div_s2;
wire [31:0] divi1_us = div_s1 ? (~divi1) + 1 : divi1;
wire [15:0] divi2_us = div_s2 ? (~divi2) + 1 : divi2;
reg [63:0] div_shifter;
reg [31:0] div_res;
reg [4:0] div_counter;
wire [31:0] div_res_s = div_s3 ? (~div_res) + 1 : div_res;
reg [1:0] mul_delay;

wire [5:0] shift_count = instr_arg_1[5] ? (~instr_arg_1[5:0]) + 1 : instr_arg_1[5:0];
wire is_lshift = !instr_arg_1[5];
wire is_rshift = instr_arg_1[5];
wire [15:0] rshift_res = $signed(regs[special_extra_reg]) >>> shift_count;
wire [15:0] lshift_res = regs[special_extra_reg] << shift_count;
wire [31:0] long_shift_in = {regs[special_extra_reg], regs[special_extra_reg | 1]};
wire [31:0] long_rshift_res = long_shift_in >> shift_count;
wire [31:0] long_lshift_res = long_shift_in << shift_count;

reg [15:0] instr_result;
reg [3:0] new_flags;
always @(*) begin
		if(is_CLR) begin
			instr_result = 16'h0000;
			new_flags = 4'b0100;
		end
		else if(is_COM) begin
			instr_result = ~instr_arg_1;
			new_flags = {is_byte_instr ? ~instr_arg_1[7] : ~instr_arg_1[15], is_byte_instr ? instr_arg_1[7:0] == 8'hFF : instr_arg_1 == 16'hFFFF, 1'b0, 1'b1};
		end
		else if(is_INC) begin
			instr_result = instr_result_inc;
			new_flags = {
				is_byte_instr ? instr_result_inc[7] : instr_result_inc[15],
				is_byte_instr ? instr_result_inc[7:0] == 0 : instr_result_inc == 0,
				is_byte_instr ? instr_arg_1[7:0] == 8'h7F : instr_arg_1 == 16'h7FFF,
				PSW[0]
			};
		end
		else if(is_DEC) begin
			instr_result = instr_result_dec;
			new_flags = {
				is_byte_instr ? instr_result_dec[7] : instr_result_dec[15],
				is_byte_instr ? instr_result_dec[7:0] == 0 : instr_result_dec == 0,
				is_byte_instr ? instr_arg_1[7:0] == 8'h00 : instr_arg_1 == 16'h0000,
				PSW[0]
			};
		end
		else if(is_NEG) begin
			instr_result = instr_result_neg;
			new_flags = {
				is_byte_instr ? instr_result_neg[7] : instr_result_neg[15],
				is_byte_instr ? instr_result_neg[7:0] == 0 : instr_result_neg == 0,
				is_byte_instr ? instr_result_neg[7:0] == 8'h80 : instr_result_neg == 16'h8000,
				is_byte_instr ? instr_result_neg[7:0] != 0 : instr_result_neg != 0
			};
		end
		else if(is_TST) begin
			instr_result = instr_arg_1;
			new_flags = {
				is_byte_instr ? instr_arg_1[7] : instr_arg_1[15],
				is_byte_instr ? instr_arg_1[7:0] == 0 : instr_arg_1 == 0,
				1'b0, 1'b0
			};
		end
		else if(is_ASR) begin
			instr_result = is_byte_instr ? {8'h00, instr_arg_1[7], instr_arg_1[7:1]} : {instr_arg_1[15], instr_arg_1[15:1]};
			new_flags = {
				is_byte_instr ? instr_arg_1[7] : instr_arg_1[15],
				is_byte_instr ? instr_arg_1[7:1] == 0 : instr_arg_1[15:1] == 0,
				is_byte_instr ? instr_arg_1[7] ^ instr_arg_1[0] : instr_arg_1[15] ^ instr_arg_1[0],
				instr_arg_1[0]
			};
		end
		else if(is_ASL) begin
			instr_result = is_byte_instr ? {8'h00, instr_arg_1[6:0], 1'b0} : {instr_arg_1[14:0], 1'b0};
			new_flags = {
				is_byte_instr ? instr_arg_1[6] : instr_arg_1[14],
				is_byte_instr ? instr_arg_1[6:0] == 0 : instr_arg_1[14:0] == 0,
				is_byte_instr ? instr_arg_1[7] ^ instr_arg_1[6] : instr_arg_1[15] ^ instr_arg_1[14],
				is_byte_instr ? instr_arg_1[7] : instr_arg_1[15]
			};
		end
		else if(is_ROR) begin
			instr_result = is_byte_instr ? {8'h00, PSW[0], instr_arg_1[7:1]} : {PSW[0], instr_arg_1[15:1]};
			new_flags = {
				PSW[0],
				is_byte_instr ? instr_arg_1[7:1] == 0 && PSW[0] == 0 : instr_arg_1[15:1] == 0 && PSW[0] == 0,
				PSW[0] ^ instr_arg_1[0],
				instr_arg_1[0]
			};
		end
		else if(is_ROL) begin
			instr_result = is_byte_instr ? {8'h00, instr_arg_1[6:0], PSW[0]} : {instr_arg_1[14:0], PSW[0]};
			new_flags = {
				is_byte_instr ? instr_arg_1[6] : instr_arg_1[14],
				is_byte_instr ? instr_arg_1[6:0] == 0 && PSW[0] == 0 : instr_arg_1[14:0] == 0 && PSW[0] == 0,
				is_byte_instr ? instr_arg_1[7] ^ instr_arg_1[6] : instr_arg_1[15] ^ instr_arg_1[14],
				is_byte_instr ? instr_arg_1[7] : instr_arg_1[15]
			};
		end
		else if(is_SWAB) begin
			instr_result = {instr_arg_1[7:0], instr_arg_1[15:8]};
			new_flags = {
				instr_arg_1[15],
				instr_arg_1[15:8] == 0,
				1'b0, 1'b0
			};
		end
		else if(is_ADC) begin
			instr_result = instr_result_adc;
			new_flags = {
				is_byte_instr ? instr_result_adc[7] : instr_result_adc[15],
				is_byte_instr ? instr_result_adc[7:0] == 0 : instr_result_adc == 0,
				is_byte_instr ? instr_arg_1[7:0] == 8'h7F && PSW[0] : instr_arg_1 == 16'h7FFF && PSW[0],
				is_byte_instr ? instr_arg_1[7:0] == 8'hFF && PSW[0] : instr_arg_1 == 16'hFFFF && PSW[0]
			};
		end
		else if(is_SBC) begin
			instr_result = instr_result_sbc;
			new_flags = {
				is_byte_instr ? instr_result_sbc[7] : instr_result_sbc[15],
				is_byte_instr ? instr_result_sbc[7:0] == 0 : instr_result_sbc == 0,
				is_byte_instr ? instr_arg_1[7:0] == 8'h80 : instr_arg_1[15:0] == 16'h8000,
				is_byte_instr ? instr_arg_1[7:0] == 8'h00 && PSW[0] : instr_arg_1 == 16'h0000 && PSW[0]
			};
		end
		else if(is_SXT) begin
			instr_result = {16{PSW[3]}};
			new_flags = {
				PSW[3],
				~PSW[3],
				PSW[1],
				PSW[0]
			};
		end
		else if(is_MFPS) begin
			instr_result = {PSW[7], PSW[7], PSW[7], PSW[7], PSW[7], PSW[7], PSW[7], PSW[7], PSW};
			new_flags = {
				PSW[7],
				PSW == 0,
				1'b0,
				PSW[0]
			};
		end
		else if(is_MTPS) begin
			instr_result = instr_arg_1;
			new_flags = instr_arg_1[3:0];
		end
		else if(is_MOV) begin
			instr_result = is_byte_instr ? {instr_arg_1[7], instr_arg_1[7], instr_arg_1[7], instr_arg_1[7], instr_arg_1[7], instr_arg_1[7], instr_arg_1[7], instr_arg_1[7], instr_arg_1[7:0]} : instr_arg_1;
			new_flags = {
				is_byte_instr ? instr_arg_1[7] : instr_arg_1[15],
				is_byte_instr ? instr_arg_1[7:0] == 0 : instr_arg_1 == 0,
				1'b0,
				PSW[0]
			};
		end
		else if(is_CMP) begin
			instr_result = instr_arg_2;
			new_flags = {
				is_byte_instr ? instr_result_cmp[7] : instr_result_cmp[15],
				is_byte_instr ? instr_result_cmp[7:0] == 0 : instr_result_cmp[15:0] == 0,
				is_byte_instr ? instr_arg_1[7] != instr_arg_2[7] && instr_result_cmp[7] == instr_arg_2[7] : instr_arg_1[15] != instr_arg_2[15] && instr_result_cmp[15] == instr_arg_2[15],
				is_byte_instr ? instr_result_cmp[8] : instr_result_cmp[16]
			};
		end
		else if(is_ADD) begin
			instr_result = instr_result_add[15:0];
			new_flags = {
				instr_result_add[15],
				instr_result_add[15:0] == 0,
				instr_arg_1[15] != instr_arg_2[15] && instr_result_add[15] == instr_arg_2[15],
				instr_result_add[16]
			};
		end
		else if(is_SUB) begin
			instr_result = instr_result_sub[15:0];
			new_flags = {
				instr_result_sub[15],
				instr_result_sub[15:0] == 0,
				instr_arg_1[15] != instr_arg_2[15] && instr_result_sub[15] == instr_arg_2[15],
				instr_result_sub[16]
			};
		end
		else if(is_BIT) begin
			instr_result = instr_arg_2;
			new_flags = {
				is_byte_instr ? instr_result_AND[7] : instr_result_AND[15],
				is_byte_instr ? instr_result_AND[7:0] == 0 : instr_result_AND == 0,
				1'b0,
				PSW[0]
			};
		end
		else if(is_BIC) begin
			instr_result = instr_result_BIC;
			new_flags = {
				is_byte_instr ? instr_result_BIC[7] : instr_result_BIC[15],
				is_byte_instr ? instr_result_BIC[7:0] == 0 : instr_result_BIC == 0,
				1'b0,
				PSW[0]
			};
		end
		else if(is_BIS) begin
			instr_result = instr_result_BIS;
			new_flags = {
				is_byte_instr ? instr_result_BIS[7] : instr_result_BIS[15],
				is_byte_instr ? instr_result_BIS[7:0] == 0 : instr_result_BIS == 0,
				1'b0,
				PSW[0]
			};
		end
		else if(is_XOR) begin
			instr_result = instr_result_XOR;
			new_flags = {
				is_byte_instr ? instr_result_XOR[7] : instr_result_XOR[15],
				is_byte_instr ? instr_result_XOR[7:0] == 0 : instr_result_XOR == 0,
				1'b0,
				PSW[0]
			};
		end
		else if(is_MUL) begin
			instr_result = instr_arg_1;
			new_flags = {
				mul_res[31],
				mul_res == 0,
				1'b0,
				!(mul_res[31:16] == 0 || mul_res[31:16] == 16'hFFFF)
			};
		end
		else if(is_DIV) begin
			instr_result = instr_arg_1;
			new_flags = {
				div_res_s[31],
				div_res_s == 0,
				instr_arg_1 == 0 || regs[special_extra_reg | 1][14:0] > instr_arg_1[14:0],
				{regs[special_extra_reg + 1], regs[special_extra_reg]} == 0
			};
		end
		else if(is_ASH) begin
			if(is_lshift) begin
				instr_result = lshift_res;
				new_flags = {
					lshift_res[15],
					lshift_res == 0,
					lshift_res[15] != regs[special_extra_reg][15],
					shift_count == 0 ? 1'b0 : regs[special_extra_reg][16 - shift_count]
				};
			end else begin
				instr_result = rshift_res;
				new_flags = {
					rshift_res[15],
					rshift_res == 0,
					rshift_res[15] != regs[special_extra_reg][15],
					shift_count == 0 ? 1'b0 : regs[special_extra_reg][shift_count - 1]
				};
			end
		end
		else if(is_ASHC) begin
			if(is_lshift) begin
				instr_result = instr_arg_1;
				new_flags = {
					long_lshift_res[31],
					long_lshift_res == 0,
					regs[special_extra_reg][15] != long_lshift_res[31],
					shift_count == 0 ? 1'b0 : long_shift_in[32 - shift_count]
				};
			end else begin
				instr_result = instr_arg_1;
				new_flags = {
					long_rshift_res[31],
					long_rshift_res == 0,
					regs[special_extra_reg][15] != long_rshift_res[31],
					shift_count == 0 ? 1'b0 : long_shift_in[shift_count - 1]
				};
			end
		end
		else if(is_IOR) begin
			instr_result = io_in;
			new_flags = {
				io_in[15],
				io_in == 0,
				1'b0,
				PSW[0]
			};
		end else begin
			instr_result = instr_arg_1;
			new_flags = PSW[3:0];
		end
end

always @(posedge clk) begin
`ifdef SIM
	if(current_addr == requested_addr) begin
		if(collission > 1 || (is_single_op && is_double_op)) begin
			$display("Colliding opcode decode! %04x", instruction);
		end else if(collission == 0) begin
			$display("Invalid opcode decode at %04x! %04x", regs[7], instruction);
			$finish();
		end
	end
`endif
	if(!rst_n || warmup != 0) begin
		regs[0] <= 16'h0000;
		regs[1] <= 16'h0000;
		regs[2] <= 16'h0000;
		regs[3] <= 16'h0000;
		regs[4] <= 16'h0000;
		regs[5] <= 16'h0000;
		regs[6] <= 16'h0000;
		regs[7] <= {start_addr, 1'b0};
		PSW <= 8'b00000000;
		current_addr <= 16'hAFAF;
		cycle <= FETCH1;
		addr_mode <= 0;
		byte_op <= 0;
		mem_io <= 0;
		instr_arg_1 <= 0;
		instr_arg_2 <= 0;
		mem_targ <= 0;
		source_index <= 16'h0000;
		dest_index <= 16'h0000;
		warmup <= rst_n ? warmup - 1 : 2'b11;
		insin <= 16'h0000;
		has_second_arg <= 0;
		waiting <= 0;
		halted <= 0;
		jmp_targ <= 0;
		handling_int <= 0;
		IVB <= 0;
		trap_targ <= 0;
		is_trap <= 0;
		last_trace_trap <= 0;
		div_shifter <= 0;
		div_res <= 0;
		div_counter <= 0;
		mul_delay <= 0;
	end else begin
		PSW[4] <= PSW[4] & trace_trap_enable;
		current_addr <= requested_addr;
		if(cycle == FETCH1) begin
			source_index <= 0;
			dest_index <= 0;
			has_second_arg <= 0;
			if(current_addr == requested_addr) begin
				insin <= bus_in;
				if(!is_BRANCH && !(last_trace_trap && PSW[4])) regs[7] <= regs[7] + 2;

				last_trace_trap <= PSW[4] && trace_trap_enable;
				if(last_trace_trap && PSW[4]) begin
					trap_targ <= 8'h02;
					is_trap <= 1'b1;
					cycle <= INT1;
				end else if((collission == 0 || collission > 1 || ((is_JMP || is_JSR) && src_mode == 0)) && illegal_trap_enable) begin
					trap_targ <= 8'h04;
					is_trap <= 1'b1;
					cycle <= INT1;
				end else if(is_WAIT || is_HALT) begin
					waiting <= is_WAIT;
					halted <= is_HALT;
					cycle <= WAIT;
				end else if(is_single_op || is_double_op || is_special) begin
					if(src_mode == 0) begin
						instr_arg_1 <= src_reg == 7 ? regs[7] + 2 : regs[src_reg];
						cycle <= is_double_op ? (dest_mode == 6 || dest_mode == 7 ? FETCH3 : ARG2) : EXEC1;
					end else begin
						byte_op <= is_byte_instr;
						addr_mode <= src_mode;
						if(src_mode == 6 || src_mode == 7) begin
							cycle <= FETCH2;
						end else begin
							if(src_mode == 4 || src_mode == 5) begin
								mem_targ <= decr_reg;
								if(src_reg == 7) regs[7] <= regs[7];
								else regs[src_reg] <= decr_reg;
							end else mem_targ <= src_reg == 7 ? regs[7] + 2 : regs[src_reg];
							if(src_mode == 2 || src_mode == 3) begin
								if(src_reg == 7) regs[7] <= regs[7] + 4;
								else regs[src_reg] <= incr_reg;
							end

							if(dest_mode == 6 || dest_mode == 7) cycle <= FETCH3;
							else cycle <= MEM1;
						end
					end
				end else if(is_BRANCH) begin
					if((!is_SOB && should_branch == instruction[8]) || (is_SOB && SOB_reg_m1 != 0)) regs[7] <= branch_targ + 2;
					else regs[7] <= regs[7] + 2;
					if(is_SOB) regs[SOB_reg] <= SOB_reg_m1;
					cycle <= FETCH1;
				end else if(is_JMP || is_JSR) begin
					if(src_mode == 0) begin
						//Exception
					end else begin
						addr_mode <= src_mode;
						if(src_mode == 6 || src_mode == 7) begin
							cycle <= FETCH2;
						end else begin
							if(src_mode == 4 || src_mode == 5) begin
								jmp_targ <= decr_reg;
								if(src_reg == 7) regs[7] <= regs[7];
								else regs[src_reg] <= decr_reg;
							end else jmp_targ <= src_reg == 7 ? regs[7] + 2 : regs[src_reg];
							if(src_mode == 2 || src_mode == 3) begin
								if(src_reg == 7) regs[7] <= regs[7] + 4;
								else regs[src_reg] <= incr_reg;
							end
							cycle <= JMP1;
						end
					end
				end else if(is_RTS || is_RTI || is_RTT || is_MARK) begin
					if(is_MARK) regs[6] <= regs[6] + {8'h00, 1'b0, instruction[5:0], 1'b0};
					cycle <= RTS1;
				end else if(is_TRAP) begin
					trap_targ <= 8'h1C;
					is_trap <= 1'b1;
					cycle <= INT1;
				end else if(is_BPT) begin
					trap_targ <= 8'h0C;
					is_trap <= 1'b1;
					cycle <= INT1;
				end else if(is_IOT) begin
					trap_targ <= 8'h10;
					is_trap <= 1'b1;
					cycle <= INT1;
				end else if(is_EMT) begin
					trap_targ <= 8'h18;
					is_trap <= 1'b1;
					cycle <= INT1;
				end else if(is_MFTP) begin
					regs[0] <= 16'h026D;
					cycle <= FETCH1;
				end else if(is_TRACE) begin
					PSW[4] <= trace_trap_enable;
					cycle <= FETCH1;
				end else if(is_SVB) begin
					IVB <= regs[0][15:5];
					cycle <= FETCH1;
				end else if(is_CCC) begin
					PSW[3:0] <= PSW[3:0] & (~instruction[3:0]);
					cycle <= FETCH1;
				end else if(is_SCC) begin
					PSW[3:0] <= PSW[3:0] | instruction[3:0];
					cycle <= FETCH1;
				end else if(is_SETD || is_SETI) cycle <= FETCH1;
				
				/*if(is_SETD) begin
					$display("setd: pc = %04, r0 = %04x\n", regs[7], regs[0]);
				end else if(is_SETI) begin
					$display("seti: pc = %04x, r0 = %04x\n", regs[7], regs[0]);
				end*/
			end
		end
		if(cycle == FETCH2) begin
			if(current_addr == requested_addr) begin
				source_index <= bus_in;
				regs[7] <= regs[7] + 2;
				if(is_JMP || is_JSR) begin
					jmp_targ <= (src_reg == 7 ? regs[7] + 2 : regs[src_reg]) + bus_in;
					cycle <= JMP1;
				end else if(is_double_op && (dest_mode == 6 || dest_mode == 7)) begin
					cycle <= FETCH3;
				end else begin
					if(is_single_op || is_special) dest_index <= bus_in;
					mem_targ <= regs[src_reg] + bus_in;
					cycle <= MEM1;
				end
			end
		end
		if(cycle == FETCH3) begin
			if(current_addr == requested_addr) begin
				regs[7] <= regs[7] + 2;
				dest_index <= bus_in;
				if(src_mode == 6 || src_mode == 7) mem_targ <= regs[src_reg] + source_index;
				cycle <= src_mode == 0 ? ARG2 : MEM1;
			end
		end
		if(cycle == ARG2) begin
			has_second_arg <= 1;
			addr_mode <= dest_mode;
			if(dest_mode == 0) begin
				instr_arg_2 <= regs[dest_reg];
				cycle <= EXEC1;
			end else begin
				if(dest_mode == 4 || dest_mode == 5) begin
					mem_targ <= dest_decr_reg;
					regs[dest_reg] <= dest_decr_reg;
				end else mem_targ <= regs[dest_reg] + dest_index;
				if(dest_mode == 2 || dest_mode == 3) regs[dest_reg] <= dest_incr_reg;
				cycle <= MEM1;
			end
		end
		if(cycle == EXEC1) begin
			if(is_MTPS) begin
				PSW <= instr_arg_1[7:0];
			end else PSW <= {PSW[7:4], new_flags};
			if(is_MUL) begin
				mul_delay <= 2'b10;
				cycle <= MUL;
			end else if(is_DIV) begin
				div_counter <= 0;
				div_shifter <= {32'h0, divi1_us};
				div_res <= 0;
				cycle <= DIV1;
			end else if(is_ASH) begin
				regs[special_extra_reg] <= instr_result;
				cycle <= FETCH1;
			end else if(is_ASHC) begin
				if(is_lshift) begin
					if(special_extra_reg[0] == 0) regs[special_extra_reg] <= long_lshift_res[31:16];
					regs[special_extra_reg | 1] <= long_lshift_res[15:0];
				end else begin
					if(special_extra_reg[0] == 0) regs[special_extra_reg] <= long_rshift_res[31:16];
					regs[special_extra_reg | 1] <= long_rshift_res[15:0];
				end
				cycle <= FETCH1;
			end else if(is_IOW) begin
				cycle <= FETCH1;
			end else if(is_TST || is_MTPS || is_CMP || is_BIT) begin
				cycle <= FETCH1;
			end else if(dest_mode == 0) begin
				if(is_byte_instr && !is_MFPS && !is_MOV) regs[dest_reg][7:0] <= instr_result[7:0];
				else regs[dest_reg] <= instr_result;

				cycle <= FETCH1;
			end else begin
				if(is_byte_instr && !requested_addr[0]) mem_io <= {mem_io[15:8], instr_result[7:0]};
				else if(is_byte_instr && requested_addr[0]) mem_io <= {instr_result[7:0], mem_io[7:0]};
				else mem_io <= instr_result;
				//mem_targ should be the same as before (read/modify/write type operation)
				cycle <= MEM2;
			end
		end

		if(cycle == MEM1) begin
			if(current_addr == requested_addr) begin
				if(is_defered_mode) begin
					cycle <= MEM1;
					mem_targ <= mem_read_val;
					addr_mode <= 1;
				end else begin
					cycle <= (is_double_op && !has_second_arg ? ARG2 : EXEC1);
					mem_io <= mem_read_val;
					if(is_single_op || is_special || (is_double_op && !has_second_arg)) instr_arg_1 <= byte_op ? (current_addr[0] ? {8'h00, mem_read_val[15:8]} : {8'h00, mem_read_val[7:0]}) : mem_read_val;
					if(is_double_op && has_second_arg) instr_arg_2 <= byte_op ? (current_addr[0] ? {8'h00, mem_read_val[15:8]} : {8'h00, mem_read_val[7:0]}) : mem_read_val;
				end
			end
		end
		if(cycle == MEM2) begin
			if(current_addr == requested_addr) begin
				cycle <= FETCH1;
			end
		end
		if(cycle == WAIT) begin
		end
		if(cycle == JMP1) begin
			if(requested_addr == current_addr) begin
				if(is_defered_mode) begin
					jmp_targ <= bus_in;
					addr_mode <= 1;
				end else begin
					if(is_JSR) begin
						regs[6] <= regs[6] - 2;
						mem_io <= regs[linkage_reg];
						cycle <= JSR1;
					end else begin
						regs[7] <= jmp_targ;
						cycle <= FETCH1;
					end
				end
			end
		end
		if(cycle == JSR1) begin
			if(requested_addr == current_addr) begin
				if(linkage_reg != 7) regs[linkage_reg] <= regs[7];
				regs[7] <= jmp_targ;
				cycle <= FETCH1;
			end
		end
		if(cycle == RTS1) begin
			if(current_addr == requested_addr) begin
				regs[6] <= regs[6] + 2;
				if(is_MARK) begin
					regs[7] <= regs[5];
					regs[5] <= bus_in;
				end else begin
					if(rts_reg != 7 && !is_RTI && !is_RTT) regs[7] <= regs[rts_reg];
					regs[is_RTI || is_RTT ? 7 : rts_reg] <= bus_in;
					cycle <= is_RTI || is_RTT ? RTI1 : FETCH1;
				end
			end
		end
		if(cycle == RTI1) begin
			if(current_addr == requested_addr) begin
				regs[6] <= regs[6] + 2;
				PSW <= is_RTT ? (bus_in[7:0] & 8'b11101111) : bus_in[7:0];
				cycle <= FETCH1;
			end
		end
		if(cycle == INT1) begin
			if(requested_addr == current_addr) begin
				regs[6] <= regs[6] - 2;
				cycle <= INT2;
			end
		end
		if(cycle == INT2) begin
			if(requested_addr == current_addr) begin
				cycle <= INT3;
			end
		end
		if(cycle == INT3) begin
			if(requested_addr == current_addr) begin
				regs[7] <= bus_in;
				cycle <= INT4;
			end
		end
		if(cycle == INT4) begin
			if(requested_addr == current_addr) begin
				PSW <= {bus_in[7:5], 1'b0, bus_in[3:0]};
				waiting <= 1'b0;
				is_trap <= 1'b0;
				cycle <= FETCH1;
			end
		end
		if(cycle == DIV1) begin
			div_res <= {div_res[30:0], div_shifter[62:31] >= divi2_us};
			if(div_shifter[62:31] >= divi2_us) begin
				div_shifter <= {div_shifter[62:31] - divi2_us, div_shifter[30:0], 1'b0};
			end else div_shifter <= {div_shifter[62:0], 1'b0};
			div_counter <= div_counter + 1;
			if(div_counter == 31) begin
				cycle <= DIV2;
			end
		end
		if(cycle == DIV2) begin
			regs[special_extra_reg] <= div_res_s[31:16];
			regs[special_extra_reg | 1] <= div_res_s[15:0];
			PSW[3:0] <= new_flags;
			cycle <= FETCH1;
			//$display("Div instr %02x / %02x = %02x\n", divi1_us, divi2_us, div_res_s);
		end
		if(cycle == MUL) begin
			mul_delay <= mul_delay - 1;
			if(mul_delay == 0) begin
				if(special_extra_reg[0] == 0) regs[special_extra_reg] <= mul_res[31:16];
				regs[special_extra_reg | 1] <= mul_res[15:0];
				PSW[3:0] <= new_flags;
				cycle <= FETCH1;
			end
		end
		if((cycle == WAIT && waiting) || (cycle == FETCH1 && current_addr != requested_addr)) begin
			if(int_reqs != 0) begin
				if(highest_int_req > PSW[7:5]) begin
					handling_int <= highest_int_req;
					regs[6] <= regs[6] - 2;
					is_trap <= 0;
					cycle <= INT1;
				end
			end
		end
	end
end

endmodule
