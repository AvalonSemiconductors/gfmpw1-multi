/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : main                                                         **
 **                                                                          **
 *****************************************************************************/

module main_ue1( CAR,
             CLK,
             DATA,
             I0,
             I1,
             I2,
             I3,
             IEN,
             JMP,
             NOPF,
             NOPO,
             OEN,
             RR,
             RST,
             RTN,
             SKIP,
             WRITE );

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input CLK;
   input DATA;
   input I0;
   input I1;
   input I2;
   input I3;
   input RST;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output CAR;
   output IEN;
   output JMP;
   output NOPF;
   output NOPO;
   output OEN;
   output RR;
   output RTN;
   output SKIP;
   output WRITE;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire s_logisimNet0;
   wire s_logisimNet1;
   wire s_logisimNet10;
   wire s_logisimNet100;
   wire s_logisimNet101;
   wire s_logisimNet102;
   wire s_logisimNet103;
   wire s_logisimNet104;
   wire s_logisimNet105;
   wire s_logisimNet106;
   wire s_logisimNet107;
   wire s_logisimNet108;
   wire s_logisimNet109;
   wire s_logisimNet11;
   wire s_logisimNet110;
   wire s_logisimNet111;
   wire s_logisimNet112;
   wire s_logisimNet113;
   wire s_logisimNet114;
   wire s_logisimNet115;
   wire s_logisimNet116;
   wire s_logisimNet117;
   wire s_logisimNet118;
   wire s_logisimNet119;
   wire s_logisimNet12;
   wire s_logisimNet120;
   wire s_logisimNet121;
   wire s_logisimNet122;
   wire s_logisimNet123;
   wire s_logisimNet124;
   wire s_logisimNet125;
   wire s_logisimNet126;
   wire s_logisimNet127;
   wire s_logisimNet128;
   wire s_logisimNet129;
   wire s_logisimNet13;
   wire s_logisimNet130;
   wire s_logisimNet131;
   wire s_logisimNet132;
   wire s_logisimNet133;
   wire s_logisimNet134;
   wire s_logisimNet135;
   wire s_logisimNet136;
   wire s_logisimNet137;
   wire s_logisimNet138;
   wire s_logisimNet139;
   wire s_logisimNet14;
   wire s_logisimNet140;
   wire s_logisimNet141;
   wire s_logisimNet142;
   wire s_logisimNet143;
   wire s_logisimNet144;
   wire s_logisimNet145;
   wire s_logisimNet146;
   wire s_logisimNet147;
   wire s_logisimNet148;
   wire s_logisimNet149;
   wire s_logisimNet15;
   wire s_logisimNet150;
   wire s_logisimNet151;
   wire s_logisimNet152;
   wire s_logisimNet153;
   wire s_logisimNet154;
   wire s_logisimNet155;
   wire s_logisimNet156;
   wire s_logisimNet157;
   wire s_logisimNet158;
   wire s_logisimNet159;
   wire s_logisimNet16;
   wire s_logisimNet160;
   wire s_logisimNet161;
   wire s_logisimNet162;
   wire s_logisimNet163;
   wire s_logisimNet164;
   wire s_logisimNet165;
   wire s_logisimNet166;
   wire s_logisimNet167;
   wire s_logisimNet168;
   wire s_logisimNet169;
   wire s_logisimNet17;
   wire s_logisimNet170;
   wire s_logisimNet171;
   wire s_logisimNet172;
   wire s_logisimNet173;
   wire s_logisimNet174;
   wire s_logisimNet175;
   wire s_logisimNet176;
   wire s_logisimNet177;
   wire s_logisimNet178;
   wire s_logisimNet179;
   wire s_logisimNet18;
   wire s_logisimNet180;
   wire s_logisimNet181;
   wire s_logisimNet182;
   wire s_logisimNet183;
   wire s_logisimNet184;
   wire s_logisimNet185;
   wire s_logisimNet186;
   wire s_logisimNet187;
   wire s_logisimNet188;
   wire s_logisimNet189;
   wire s_logisimNet19;
   wire s_logisimNet190;
   wire s_logisimNet191;
   wire s_logisimNet192;
   wire s_logisimNet193;
   wire s_logisimNet194;
   wire s_logisimNet195;
   wire s_logisimNet196;
   wire s_logisimNet2;
   wire s_logisimNet20;
   wire s_logisimNet21;
   wire s_logisimNet22;
   wire s_logisimNet23;
   wire s_logisimNet24;
   wire s_logisimNet25;
   wire s_logisimNet26;
   wire s_logisimNet27;
   wire s_logisimNet28;
   wire s_logisimNet29;
   wire s_logisimNet3;
   wire s_logisimNet30;
   wire s_logisimNet31;
   wire s_logisimNet32;
   wire s_logisimNet33;
   wire s_logisimNet34;
   wire s_logisimNet35;
   wire s_logisimNet36;
   wire s_logisimNet37;
   wire s_logisimNet38;
   wire s_logisimNet39;
   wire s_logisimNet4;
   wire s_logisimNet40;
   wire s_logisimNet41;
   wire s_logisimNet42;
   wire s_logisimNet43;
   wire s_logisimNet44;
   wire s_logisimNet45;
   wire s_logisimNet46;
   wire s_logisimNet47;
   wire s_logisimNet48;
   wire s_logisimNet49;
   wire s_logisimNet5;
   wire s_logisimNet50;
   wire s_logisimNet51;
   wire s_logisimNet52;
   wire s_logisimNet53;
   wire s_logisimNet54;
   wire s_logisimNet55;
   wire s_logisimNet56;
   wire s_logisimNet57;
   wire s_logisimNet58;
   wire s_logisimNet59;
   wire s_logisimNet6;
   wire s_logisimNet60;
   wire s_logisimNet61;
   wire s_logisimNet62;
   wire s_logisimNet63;
   wire s_logisimNet64;
   wire s_logisimNet65;
   wire s_logisimNet66;
   wire s_logisimNet67;
   wire s_logisimNet68;
   wire s_logisimNet69;
   wire s_logisimNet7;
   wire s_logisimNet70;
   wire s_logisimNet71;
   wire s_logisimNet72;
   wire s_logisimNet73;
   wire s_logisimNet74;
   wire s_logisimNet75;
   wire s_logisimNet76;
   wire s_logisimNet77;
   wire s_logisimNet78;
   wire s_logisimNet79;
   wire s_logisimNet8;
   wire s_logisimNet80;
   wire s_logisimNet81;
   wire s_logisimNet82;
   wire s_logisimNet83;
   wire s_logisimNet84;
   wire s_logisimNet85;
   wire s_logisimNet86;
   wire s_logisimNet87;
   wire s_logisimNet88;
   wire s_logisimNet89;
   wire s_logisimNet9;
   wire s_logisimNet90;
   wire s_logisimNet91;
   wire s_logisimNet92;
   wire s_logisimNet93;
   wire s_logisimNet94;
   wire s_logisimNet95;
   wire s_logisimNet96;
   wire s_logisimNet97;
   wire s_logisimNet98;
   wire s_logisimNet99;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here all input connections are defined                                     **
   *******************************************************************************/
   assign s_logisimNet10  = RST;
   assign s_logisimNet105 = I0;
   assign s_logisimNet133 = DATA;
   assign s_logisimNet135 = I1;
   assign s_logisimNet154 = I3;
   assign s_logisimNet28  = CLK;
   assign s_logisimNet96  = I2;

   /*******************************************************************************
   ** Here all output connections are defined                                    **
   *******************************************************************************/
   assign CAR   = s_logisimNet17;
   assign IEN   = s_logisimNet90;
   assign JMP   = s_logisimNet34;
   assign NOPF  = s_logisimNet159;
   assign NOPO  = s_logisimNet69;
   assign OEN   = s_logisimNet58;
   assign RR    = s_logisimNet185;
   assign RTN   = s_logisimNet33;
   assign SKIP  = s_logisimNet41;
   assign WRITE = s_logisimNet115;

   /*******************************************************************************
   ** Here all in-lined components are defined                                   **
   *******************************************************************************/

   // Buffer
   assign s_logisimNet18 = s_logisimNet132;

   // Buffer
   assign s_logisimNet83 = s_logisimNet163;

   // Buffer
   assign s_logisimNet4 = s_logisimNet77;

   // Buffer
   assign s_logisimNet169 = s_logisimNet171;

   // Buffer
   assign s_logisimNet69 = s_logisimNet160;

   // Buffer
   assign s_logisimNet20 = s_logisimNet52;

   // Buffer
   assign s_logisimNet33 = s_logisimNet168;

   // NOT Gate
   assign s_logisimNet158 = ~s_logisimNet196;

   // Buffer
   assign s_logisimNet16 = s_logisimNet79;

   // Buffer
   assign s_logisimNet115 = s_logisimNet158;

   // Buffer
   assign s_logisimNet72 = s_logisimNet120;

   // Buffer
   assign s_logisimNet37 = s_logisimNet8;

   // NOT Gate
   assign s_logisimNet19 = ~s_logisimNet28;

   // Buffer
   assign s_logisimNet46 = s_logisimNet155;

   // Buffer
   assign s_logisimNet111 = s_logisimNet165;

   // NOT Gate
   assign s_logisimNet39 = ~s_logisimNet190;

   // Buffer
   assign s_logisimNet38 = s_logisimNet112;

   // NOT Gate
   assign s_logisimNet149 = ~s_logisimNet140;

   // Buffer
   assign s_logisimNet80 = s_logisimNet128;

   // Buffer
   assign s_logisimNet99 = s_logisimNet41;

   // Buffer
   assign s_logisimNet59 = s_logisimNet142;

   // Buffer
   assign s_logisimNet84 = s_logisimNet131;

   // Buffer
   assign s_logisimNet51 = s_logisimNet91;

   // Buffer
   assign s_logisimNet73 = s_logisimNet186;

   // NOT Gate
   assign s_logisimNet92 = ~s_logisimNet192;

   // Buffer
   assign s_logisimNet103 = s_logisimNet74;

   // NOT Gate
   assign s_logisimNet42 = ~s_logisimNet9;

   // NOT Gate
   assign s_logisimNet131 = ~s_logisimNet28;

   // Buffer
   assign s_logisimNet6 = s_logisimNet24;

   // Buffer
   assign s_logisimNet11 = s_logisimNet67;

   // Buffer
   assign s_logisimNet175 = s_logisimNet178;

   // NOT Gate
   assign s_logisimNet188 = ~s_logisimNet193;

   // NOT Gate
   assign s_logisimNet95 = ~s_logisimNet184;

   // NOT Gate
   assign s_logisimNet54 = ~s_logisimNet191;

   // NOT Gate
   assign s_logisimNet40 = ~s_logisimNet166;

   // Buffer
   assign s_logisimNet159 = s_logisimNet95;

   // NOT Gate
   assign s_logisimNet93 = ~s_logisimNet13;

   // Buffer
   assign s_logisimNet13 = s_logisimNet177;

   // NOT Gate
   assign s_logisimNet187 = ~s_logisimNet194;

   // Buffer
   assign s_logisimNet17 = s_logisimNet143;

   // Buffer
   assign s_logisimNet45 = s_logisimNet108;

   // Buffer
   assign s_logisimNet185 = s_logisimNet11;

   // Buffer
   assign s_logisimNet179 = s_logisimNet181;

   // Buffer
   assign s_logisimNet122 = s_logisimNet150;

   // Buffer
   assign s_logisimNet9 = s_logisimNet180;

   // Buffer
   assign s_logisimNet172 = s_logisimNet173;

   // NOT Gate
   assign s_logisimNet144 = ~s_logisimNet100;

   // Buffer
   assign s_logisimNet125 = s_logisimNet162;

   // NOT Gate
   assign s_logisimNet63 = ~s_logisimNet28;

   // Buffer
   assign s_logisimNet2 = s_logisimNet32;

   // Buffer
   assign s_logisimNet31 = s_logisimNet137;

   // NOT Gate
   assign s_logisimNet176 = ~s_logisimNet195;

   // Buffer
   assign s_logisimNet66 = s_logisimNet189;

   // Buffer
   assign s_logisimNet75 = s_logisimNet64;

   // Buffer
   assign s_logisimNet130 = s_logisimNet183;

   // NOT Gate
   assign s_logisimNet180 = ~s_logisimNet27;

   // Buffer
   assign s_logisimNet34 = s_logisimNet174;

   // NOT Gate
   assign s_logisimNet50 = ~s_logisimNet167;

   /*******************************************************************************
   ** Here all normal components are defined                                     **
   *******************************************************************************/
   NOR_GATE #(.BubblesMask(2'b00))
      GATES_1 (.input1(s_logisimNet11),
               .input2(s_logisimNet16),
               .result(s_logisimNet57));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_2 (.input1(s_logisimNet10),
               .input2(s_logisimNet119),
               .result(s_logisimNet89));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_3 (.input1(s_logisimNet77),
               .input2(s_logisimNet3),
               .result(s_logisimNet108));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_4 (.input1(s_logisimNet102),
               .input2(s_logisimNet26),
               .result(s_logisimNet65));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_5 (.input1(s_logisimNet97),
               .input2(s_logisimNet156),
               .result(s_logisimNet113));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_6 (.input1(s_logisimNet134),
               .input2(s_logisimNet109),
               .result(s_logisimNet79));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_7 (.input1(s_logisimNet14),
               .input2(s_logisimNet104),
               .result(s_logisimNet7));

   NOR_GATE_4_INPUTS #(.BubblesMask(4'h0))
      GATES_8 (.input1(s_logisimNet20),
               .input2(s_logisimNet2),
               .input3(s_logisimNet72),
               .input4(s_logisimNet45),
               .result(s_logisimNet174));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_9 (.input1(s_logisimNet29),
               .input2(s_logisimNet119),
               .result(s_logisimNet21));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_10 (.input1(s_logisimNet149),
                .input2(s_logisimNet50),
                .result(s_logisimNet163));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_11 (.input1(s_logisimNet43),
                .input2(s_logisimNet108),
                .result(s_logisimNet77));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_12 (.input1(s_logisimNet66),
                .input2(s_logisimNet6),
                .result(s_logisimNet35));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_13 (.input1(s_logisimNet54),
                .input2(s_logisimNet55),
                .result(s_logisimNet126));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_14 (.input1(s_logisimNet61),
                .input2(s_logisimNet120),
                .result(s_logisimNet8));

   NOR_GATE_3_INPUTS #(.BubblesMask(3'b000))
      GATES_15 (.input1(s_logisimNet119),
                .input2(s_logisimNet84),
                .input3(s_logisimNet29),
                .result(s_logisimNet70));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_16 (.input1(s_logisimNet144),
                .input2(s_logisimNet40),
                .result(s_logisimNet127));

   NOR_GATE_3_INPUTS #(.BubblesMask(3'b000))
      GATES_17 (.input1(s_logisimNet76),
                .input2(s_logisimNet10),
                .input3(s_logisimNet65),
                .result(s_logisimNet102));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_18 (.input1(s_logisimNet88),
                .input2(s_logisimNet19),
                .result(s_logisimNet48));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_19 (.input1(s_logisimNet30),
                .input2(s_logisimNet172),
                .result(s_logisimNet44));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_20 (.input1(s_logisimNet123),
                .input2(s_logisimNet84),
                .result(s_logisimNet101));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_21 (.input1(s_logisimNet182),
                .input2(s_logisimNet0),
                .result(s_logisimNet90));

   NAND_GATE #(.BubblesMask(2'b00))
      GATES_22 (.input1(s_logisimNet73),
                .input2(s_logisimNet28),
                .result(s_logisimNet145));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_23 (.input1(s_logisimNet187),
                .input2(s_logisimNet18),
                .result(s_logisimNet110));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_24 (.input1(s_logisimNet118),
                .input2(s_logisimNet63),
                .result(s_logisimNet62));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_25 (.input1(s_logisimNet136),
                .input2(s_logisimNet84),
                .result(s_logisimNet107));

   NOR_GATE_3_INPUTS #(.BubblesMask(3'b000))
      GATES_26 (.input1(s_logisimNet87),
                .input2(s_logisimNet84),
                .input3(s_logisimNet22),
                .result(s_logisimNet3));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_27 (.input1(s_logisimNet10),
                .input2(s_logisimNet101),
                .result(s_logisimNet61));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_28 (.input1(s_logisimNet138),
                .input2(s_logisimNet153),
                .result(s_logisimNet58));

   NOR_GATE_3_INPUTS #(.BubblesMask(3'b000))
      GATES_29 (.input1(s_logisimNet107),
                .input2(s_logisimNet84),
                .input3(s_logisimNet1),
                .result(s_logisimNet49));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_30 (.input1(s_logisimNet135),
                .input2(s_logisimNet99),
                .result(s_logisimNet178));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_31 (.input1(s_logisimNet8),
                .input2(s_logisimNet30),
                .result(s_logisimNet120));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_32 (.input1(s_logisimNet97),
                .input2(s_logisimNet13),
                .result(s_logisimNet121));

   NOR_GATE_3_INPUTS #(.BubblesMask(3'b000))
      GATES_33 (.input1(s_logisimNet101),
                .input2(s_logisimNet84),
                .input3(s_logisimNet44),
                .result(s_logisimNet30));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_34 (.input1(s_logisimNet82),
                .input2(s_logisimNet93),
                .result(s_logisimNet106));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_35 (.input1(s_logisimNet39),
                .input2(s_logisimNet54),
                .result(s_logisimNet151));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_36 (.input1(s_logisimNet78),
                .input2(s_logisimNet128),
                .result(s_logisimNet32));

   NOR_GATE_4_INPUTS #(.BubblesMask(4'h0))
      GATES_37 (.input1(s_logisimNet20),
                .input2(s_logisimNet80),
                .input3(s_logisimNet72),
                .input4(s_logisimNet45),
                .result(s_logisimNet165));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_38 (.input1(s_logisimNet7),
                .input2(s_logisimNet53),
                .result(s_logisimNet146));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_39 (.input1(s_logisimNet90),
                .input2(s_logisimNet12),
                .result(s_logisimNet0));

   NOR_GATE_4_INPUTS #(.BubblesMask(4'h0))
      GATES_40 (.input1(s_logisimNet31),
                .input2(s_logisimNet2),
                .input3(s_logisimNet37),
                .input4(s_logisimNet4),
                .result(s_logisimNet155));

   NOR_GATE_4_INPUTS #(.BubblesMask(4'h0))
      GATES_41 (.input1(s_logisimNet20),
                .input2(s_logisimNet80),
                .input3(s_logisimNet37),
                .input4(s_logisimNet4),
                .result(s_logisimNet150));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_42 (.input1(s_logisimNet133),
                .input2(s_logisimNet83),
                .result(s_logisimNet116));

   NAND_GATE #(.BubblesMask(2'b00))
      GATES_43 (.input1(s_logisimNet130),
                .input2(s_logisimNet28),
                .result(s_logisimNet26));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_44 (.input1(s_logisimNet139),
                .input2(s_logisimNet13),
                .result(s_logisimNet97));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_45 (.input1(s_logisimNet23),
                .input2(s_logisimNet68),
                .result(s_logisimNet5));

   NOR_GATE_3_INPUTS #(.BubblesMask(3'b000))
      GATES_46 (.input1(s_logisimNet48),
                .input2(s_logisimNet19),
                .input3(s_logisimNet60),
                .result(s_logisimNet114));

   NAND_GATE #(.BubblesMask(2'b00))
      GATES_47 (.input1(s_logisimNet103),
                .input2(s_logisimNet66),
                .result(s_logisimNet167));

   NOR_GATE_4_INPUTS #(.BubblesMask(4'h0))
      GATES_48 (.input1(s_logisimNet31),
                .input2(s_logisimNet2),
                .input3(s_logisimNet37),
                .input4(s_logisimNet45),
                .result(s_logisimNet189));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_49 (.input1(s_logisimNet18),
                .input2(s_logisimNet157),
                .result(s_logisimNet139));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_50 (.input1(s_logisimNet10),
                .input2(s_logisimNet48),
                .result(s_logisimNet129));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_51 (.input1(s_logisimNet52),
                .input2(s_logisimNet70),
                .result(s_logisimNet137));

   NAND_GATE #(.BubblesMask(2'b00))
      GATES_52 (.input1(s_logisimNet141),
                .input2(s_logisimNet17),
                .result(s_logisimNet191));

   NAND_GATE #(.BubblesMask(2'b00))
      GATES_53 (.input1(s_logisimNet127),
                .input2(s_logisimNet125),
                .result(s_logisimNet100));

   NAND_GATE #(.BubblesMask(2'b00))
      GATES_54 (.input1(s_logisimNet11),
                .input2(s_logisimNet6),
                .result(s_logisimNet140));

   OR_GATE_4_INPUTS #(.BubblesMask(4'h0))
      GATES_55 (.input1(s_logisimNet176),
                .input2(s_logisimNet110),
                .input3(s_logisimNet92),
                .input4(s_logisimNet146),
                .result(s_logisimNet148));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_56 (.input1(s_logisimNet114),
                .input2(s_logisimNet188),
                .result(s_logisimNet60));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_57 (.input1(s_logisimNet118),
                .input2(s_logisimNet152),
                .result(s_logisimNet86));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_58 (.input1(s_logisimNet82),
                .input2(s_logisimNet85),
                .result(s_logisimNet143));

   NAND_GATE #(.BubblesMask(2'b00))
      GATES_59 (.input1(s_logisimNet126),
                .input2(s_logisimNet161),
                .result(s_logisimNet195));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_60 (.input1(s_logisimNet22),
                .input2(s_logisimNet87),
                .result(s_logisimNet117));

   NOR_GATE_4_INPUTS #(.BubblesMask(4'h0))
      GATES_61 (.input1(s_logisimNet31),
                .input2(s_logisimNet2),
                .input3(s_logisimNet72),
                .input4(s_logisimNet45),
                .result(s_logisimNet168));

   NOR_GATE_3_INPUTS #(.BubblesMask(3'b000))
      GATES_62 (.input1(s_logisimNet65),
                .input2(s_logisimNet26),
                .input3(s_logisimNet76),
                .result(s_logisimNet25));

   NOR_GATE_4_INPUTS #(.BubblesMask(4'h0))
      GATES_63 (.input1(s_logisimNet31),
                .input2(s_logisimNet80),
                .input3(s_logisimNet37),
                .input4(s_logisimNet45),
                .result(s_logisimNet183));

   NAND_GATE #(.BubblesMask(2'b00))
      GATES_64 (.input1(s_logisimNet11),
                .input2(s_logisimNet16),
                .result(s_logisimNet190));

   NOR_GATE_4_INPUTS #(.BubblesMask(4'h0))
      GATES_65 (.input1(s_logisimNet20),
                .input2(s_logisimNet2),
                .input3(s_logisimNet37),
                .input4(s_logisimNet4),
                .result(s_logisimNet160));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_66 (.input1(s_logisimNet12),
                .input2(s_logisimNet116),
                .result(s_logisimNet23));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_67 (.input1(s_logisimNet1),
                .input2(s_logisimNet107),
                .result(s_logisimNet136));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_68 (.input1(s_logisimNet99),
                .input2(s_logisimNet154),
                .result(s_logisimNet171));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_69 (.input1(s_logisimNet5),
                .input2(s_logisimNet145),
                .result(s_logisimNet68));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_70 (.input1(s_logisimNet32),
                .input2(s_logisimNet49),
                .result(s_logisimNet128));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_71 (.input1(s_logisimNet39),
                .input2(s_logisimNet57),
                .result(s_logisimNet141));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_72 (.input1(s_logisimNet113),
                .input2(s_logisimNet93),
                .result(s_logisimNet82));

   NOR_GATE_4_INPUTS #(.BubblesMask(4'h0))
      GATES_73 (.input1(s_logisimNet20),
                .input2(s_logisimNet80),
                .input3(s_logisimNet72),
                .input4(s_logisimNet4),
                .result(s_logisimNet91));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_74 (.input1(s_logisimNet70),
                .input2(s_logisimNet179),
                .result(s_logisimNet29));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_75 (.input1(s_logisimNet44),
                .input2(s_logisimNet101),
                .result(s_logisimNet123));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_76 (.input1(s_logisimNet9),
                .input2(s_logisimNet59),
                .result(s_logisimNet147));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_77 (.input1(s_logisimNet60),
                .input2(s_logisimNet48),
                .result(s_logisimNet88));

   NAND_GATE #(.BubblesMask(2'b00))
      GATES_78 (.input1(s_logisimNet56),
                .input2(s_logisimNet164),
                .result(s_logisimNet192));

   NOR_GATE_4_INPUTS #(.BubblesMask(4'h0))
      GATES_79 (.input1(s_logisimNet20),
                .input2(s_logisimNet80),
                .input3(s_logisimNet37),
                .input4(s_logisimNet45),
                .result(s_logisimNet186));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_80 (.input1(s_logisimNet33),
                .input2(s_logisimNet103),
                .result(s_logisimNet81));

   NOR_GATE_3_INPUTS #(.BubblesMask(3'b000))
      GATES_81 (.input1(s_logisimNet51),
                .input2(s_logisimNet42),
                .input3(s_logisimNet103),
                .result(s_logisimNet15));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_82 (.input1(s_logisimNet59),
                .input2(s_logisimNet122),
                .result(s_logisimNet161));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_83 (.input1(s_logisimNet141),
                .input2(s_logisimNet17),
                .result(s_logisimNet55));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_84 (.input1(s_logisimNet89),
                .input2(s_logisimNet137),
                .result(s_logisimNet52));

   NOR_GATE_4_INPUTS #(.BubblesMask(4'h0))
      GATES_85 (.input1(s_logisimNet20),
                .input2(s_logisimNet2),
                .input3(s_logisimNet72),
                .input4(s_logisimNet4),
                .result(s_logisimNet132));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_86 (.input1(s_logisimNet3),
                .input2(s_logisimNet169),
                .result(s_logisimNet22));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_87 (.input1(s_logisimNet9),
                .input2(s_logisimNet147),
                .result(s_logisimNet134));

   NAND_GATE #(.BubblesMask(2'b00))
      GATES_88 (.input1(s_logisimNet28),
                .input2(s_logisimNet170),
                .result(s_logisimNet177));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_89 (.input1(s_logisimNet96),
                .input2(s_logisimNet99),
                .result(s_logisimNet173));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_90 (.input1(s_logisimNet117),
                .input2(s_logisimNet84),
                .result(s_logisimNet87));

   NAND_GATE_3_INPUTS #(.BubblesMask(3'b000))
      GATES_91 (.input1(s_logisimNet81),
                .input2(s_logisimNet47),
                .input3(s_logisimNet94),
                .result(s_logisimNet193));

   OR_GATE_3_INPUTS #(.BubblesMask(3'b000))
      GATES_92 (.input1(s_logisimNet46),
                .input2(s_logisimNet59),
                .input3(s_logisimNet122),
                .result(s_logisimNet104));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_93 (.input1(s_logisimNet36),
                .input2(s_logisimNet74),
                .result(s_logisimNet67));

   OR_GATE_3_INPUTS #(.BubblesMask(3'b000))
      GATES_94 (.input1(s_logisimNet122),
                .input2(s_logisimNet59),
                .input3(s_logisimNet18),
                .result(s_logisimNet170));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_95 (.input1(s_logisimNet129),
                .input2(s_logisimNet94),
                .result(s_logisimNet41));

   NOR_GATE_3_INPUTS #(.BubblesMask(3'b000))
      GATES_96 (.input1(s_logisimNet71),
                .input2(s_logisimNet98),
                .input3(s_logisimNet15),
                .result(s_logisimNet56));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_97 (.input1(s_logisimNet49),
                .input2(s_logisimNet175),
                .result(s_logisimNet1));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_98 (.input1(s_logisimNet41),
                .input2(s_logisimNet114),
                .result(s_logisimNet94));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_99 (.input1(s_logisimNet86),
                .input2(s_logisimNet28),
                .result(s_logisimNet36));

   NAND_GATE #(.BubblesMask(2'b00))
      GATES_100 (.input1(s_logisimNet99),
                 .input2(s_logisimNet125),
                 .result(s_logisimNet166));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_101 (.input1(s_logisimNet18),
                 .input2(s_logisimNet151),
                 .result(s_logisimNet157));

   NOR_GATE_4_INPUTS #(.BubblesMask(4'h0))
      GATES_102 (.input1(s_logisimNet31),
                 .input2(s_logisimNet2),
                 .input3(s_logisimNet72),
                 .input4(s_logisimNet4),
                 .result(s_logisimNet112));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_103 (.input1(s_logisimNet10),
                 .input2(s_logisimNet68),
                 .result(s_logisimNet182));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_104 (.input1(s_logisimNet7),
                 .input2(s_logisimNet11),
                 .result(s_logisimNet53));

   NOR_GATE_3_INPUTS #(.BubblesMask(3'b000))
      GATES_105 (.input1(s_logisimNet68),
                 .input2(s_logisimNet145),
                 .input3(s_logisimNet23),
                 .result(s_logisimNet12));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_106 (.input1(s_logisimNet10),
                 .input2(s_logisimNet65),
                 .result(s_logisimNet138));

   NOR_GATE_4_INPUTS #(.BubblesMask(4'h0))
      GATES_107 (.input1(s_logisimNet31),
                 .input2(s_logisimNet80),
                 .input3(s_logisimNet72),
                 .input4(s_logisimNet4),
                 .result(s_logisimNet64));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_108 (.input1(s_logisimNet36),
                 .input2(s_logisimNet28),
                 .result(s_logisimNet124));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_109 (.input1(s_logisimNet58),
                 .input2(s_logisimNet25),
                 .result(s_logisimNet153));

   NAND_GATE #(.BubblesMask(2'b00))
      GATES_110 (.input1(s_logisimNet9),
                 .input2(s_logisimNet46),
                 .result(s_logisimNet194));

   NAND_GATE #(.BubblesMask(2'b00))
      GATES_111 (.input1(s_logisimNet116),
                 .input2(s_logisimNet90),
                 .result(s_logisimNet27));

   NOR_GATE_4_INPUTS #(.BubblesMask(4'h0))
      GATES_112 (.input1(s_logisimNet31),
                 .input2(s_logisimNet80),
                 .input3(s_logisimNet72),
                 .input4(s_logisimNet45),
                 .result(s_logisimNet162));

   NOR_GATE_3_INPUTS #(.BubblesMask(3'b000))
      GATES_113 (.input1(s_logisimNet86),
                 .input2(s_logisimNet10),
                 .input3(s_logisimNet62),
                 .result(s_logisimNet152));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_114 (.input1(s_logisimNet147),
                 .input2(s_logisimNet59),
                 .result(s_logisimNet109));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_115 (.input1(s_logisimNet10),
                 .input2(s_logisimNet107),
                 .result(s_logisimNet78));

   NOR_GATE_4_INPUTS #(.BubblesMask(4'h0))
      GATES_116 (.input1(s_logisimNet20),
                 .input2(s_logisimNet2),
                 .input3(s_logisimNet37),
                 .input4(s_logisimNet45),
                 .result(s_logisimNet24));

   NAND_GATE_3_INPUTS #(.BubblesMask(3'b000))
      GATES_117 (.input1(s_logisimNet28),
                 .input2(s_logisimNet58),
                 .input3(s_logisimNet35),
                 .result(s_logisimNet196));

   OR_GATE_3_INPUTS #(.BubblesMask(3'b000))
      GATES_118 (.input1(s_logisimNet38),
                 .input2(s_logisimNet51),
                 .input3(s_logisimNet75),
                 .result(s_logisimNet14));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_119 (.input1(s_logisimNet67),
                 .input2(s_logisimNet124),
                 .result(s_logisimNet74));

   NOR_GATE_3_INPUTS #(.BubblesMask(3'b000))
      GATES_120 (.input1(s_logisimNet25),
                 .input2(s_logisimNet10),
                 .input3(s_logisimNet116),
                 .result(s_logisimNet76));

   OR_GATE_3_INPUTS #(.BubblesMask(3'b000))
      GATES_121 (.input1(s_logisimNet38),
                 .input2(s_logisimNet51),
                 .input3(s_logisimNet75),
                 .result(s_logisimNet164));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_122 (.input1(s_logisimNet148),
                 .input2(s_logisimNet63),
                 .result(s_logisimNet118));

   NOR_GATE_3_INPUTS #(.BubblesMask(3'b000))
      GATES_123 (.input1(s_logisimNet38),
                 .input2(s_logisimNet9),
                 .input3(s_logisimNet11),
                 .result(s_logisimNet71));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_124 (.input1(s_logisimNet10),
                 .input2(s_logisimNet87),
                 .result(s_logisimNet43));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_125 (.input1(s_logisimNet111),
                 .input2(s_logisimNet33),
                 .result(s_logisimNet47));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_126 (.input1(s_logisimNet105),
                 .input2(s_logisimNet99),
                 .result(s_logisimNet181));

   NOR_GATE #(.BubblesMask(2'b00))
      GATES_127 (.input1(s_logisimNet21),
                 .input2(s_logisimNet84),
                 .result(s_logisimNet119));

   NAND_GATE #(.BubblesMask(2'b00))
      GATES_128 (.input1(s_logisimNet100),
                 .input2(s_logisimNet125),
                 .result(s_logisimNet184));

   NOR_GATE_3_INPUTS #(.BubblesMask(3'b000))
      GATES_129 (.input1(s_logisimNet38),
                 .input2(s_logisimNet9),
                 .input3(s_logisimNet11),
                 .result(s_logisimNet98));

   NOR_GATE_4_INPUTS #(.BubblesMask(4'h0))
      GATES_130 (.input1(s_logisimNet31),
                 .input2(s_logisimNet80),
                 .input3(s_logisimNet37),
                 .input4(s_logisimNet4),
                 .result(s_logisimNet142));

   NOR_GATE_3_INPUTS #(.BubblesMask(3'b000))
      GATES_131 (.input1(s_logisimNet143),
                 .input2(s_logisimNet10),
                 .input3(s_logisimNet106),
                 .result(s_logisimNet85));

   NOR_GATE_3_INPUTS #(.BubblesMask(3'b000))
      GATES_132 (.input1(s_logisimNet113),
                 .input2(s_logisimNet10),
                 .input3(s_logisimNet121),
                 .result(s_logisimNet156));


endmodule
