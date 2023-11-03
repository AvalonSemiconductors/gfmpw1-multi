/* verilator lint_off WIDTH */
`default_nettype none

module tt_um_rejunity_sn76489 #( parameter CHANNEL_OUTPUT_BITS = 10,
                                 parameter MASTER_OUTPUT_BITS = 8,
                                 parameter SPI_MASTER_OUTPUT_BITS = 12
) (
    input clk,
    input rst_n,
    input [7:0] data,
    input [1:0] master_clock_control,
    input web,
    output [4:0] pwms,
    output [7:0] raw_sample,
    output DAC_clk,
    output DAC_le,
    output DAC_dat
);
    localparam NUM_TONES = 3;
    localparam NUM_NOISES = 1;
    localparam ATTENUATION_CONTROL_BITS = 4;
    localparam FREQUENCY_COUNTER_BITS = 10;
    localparam NOISE_CONTROL_BITS = 3;
    wire reset = ! rst_n;

    wire we = ! web;

    reg [$clog2(128)-1:0] clk_counter;
    reg clk_master_strobe;
    always @(*) begin
        case(master_clock_control[1:0])
            2'b01:  clk_master_strobe = 1'b1;                                // no div, for old SN94624/SN76494 at 250Khz
                                                                            // also useful to speedup record.py
            2'b10:  clk_master_strobe = clk_counter[$clog2(128)-1:0] == 0;  // div 128, for TinyTapeout5 running 32..50Mhz
            default:
                    clk_master_strobe = clk_counter[$clog2(16)-1:0] == 0;   // div  16, for standard SN76489 
                                                                            // running 4Mhz or NTCS/PAL frequencies
        endcase
    end

    // The SN76489 has 8 control "registers":
    // - 4 x 4 bit volume registers (attenuation)
    // - 3 x 10 bit tone registers  (frequency)
    // - 1 x 3 bit noise register
    localparam NUM_CHANNELS = NUM_TONES + NUM_NOISES;    
    reg [ATTENUATION_CONTROL_BITS-1:0]  control_attn[NUM_CHANNELS-1:0];
    reg [FREQUENCY_COUNTER_BITS-1:0]    control_tone_freq[NUM_TONES-1:0];
    reg [NOISE_CONTROL_BITS-1:0]        control_noise[NUM_NOISES-1:0];
    reg [2:0] latch_control_reg;
    reg restart_noise;

    always @(posedge clk) begin
        if (reset) begin
            clk_counter <= 0;

            control_attn[0] <= 4'b1111;
            control_attn[1] <= 4'b1111;
            control_attn[2] <= 4'b1111;
            control_attn[3] <= 4'b1111;
            control_tone_freq[0] <= 1;
            control_tone_freq[1] <= 1;
            control_tone_freq[2] <= 1;
            control_noise[0] <= 3'b100;

            latch_control_reg <= 0;
            restart_noise <= 0;
        end else begin
            clk_counter <= clk_counter + 1;                                 // provides clk_master_strobe for tone & noise generators
            restart_noise <= 0;
            if (we) begin
                if (data[7] == 1'b1) begin
                    case(data[6:4])
                        3'b000 : control_tone_freq[0][3:0] <= data[3:0];
                        3'b010 : control_tone_freq[1][3:0] <= data[3:0];
                        3'b100 : control_tone_freq[2][3:0] <= data[3:0];
                        3'b110 : 
                            begin 
                                control_noise[0] <= data[2:0];
                                restart_noise <= 1;
                            end
                        3'b001 : control_attn[0] <= data[3:0];
                        3'b011 : control_attn[1] <= data[3:0];
                        3'b101 : control_attn[2] <= data[3:0];
                        3'b111 : control_attn[3] <= data[3:0];
                        default : begin end
                    endcase
                    latch_control_reg <= data[6:4];
                end else begin
                    case(latch_control_reg)
                        3'b000 : control_tone_freq[0][9:4] <= data[5:0];
                        3'b010 : control_tone_freq[1][9:4] <= data[5:0];
                        3'b100 : control_tone_freq[2][9:4] <= data[5:0];
                        3'b001 : control_attn[0] <= data[3:0];
                        3'b011 : control_attn[1] <= data[3:0];
                        3'b101 : control_attn[2] <= data[3:0];
                        3'b111 : control_attn[3] <= data[3:0];
                        default : begin end
                    endcase
                end
            end
        end
    end

    wire                           channels [NUM_CHANNELS-1:0];
    wire [CHANNEL_OUTPUT_BITS-1:0] volumes  [NUM_CHANNELS-1:0];

    genvar i;
    generate
        for (i = 0; i < NUM_TONES; i = i + 1) begin : tone
            tone #(.COUNTER_BITS(FREQUENCY_COUNTER_BITS)) gen (
                .clk(clk),
                .enable(clk_master_strobe),
                .reset(reset),
                .compare(control_tone_freq[i]),
                .out(channels[i])
                );
        end

        for (i = 0; i < NUM_NOISES; i = i + 1) begin : noise
            noise #(.COUNTER_BITS(FREQUENCY_COUNTER_BITS)) gen (
                .clk(clk),
                .enable(clk_master_strobe),
                .reset(reset),
                .restart_noise(restart_noise),
                .control(control_noise[i]),
                .driven_by_tone(channels[NUM_TONES-1]), // can be driven by the last tone,
                                                        // when control_noise[1:0] == 2'b11
                .out(channels[NUM_TONES+i])
                );
        end

        for (i = 0; i < NUM_CHANNELS; i = i + 1) begin : chan
            attenuation #(.VOLUME_BITS(CHANNEL_OUTPUT_BITS)) attenuation (
                .in(channels[i]),
                .control(control_attn[i]),
                .out(volumes[i])
                );
        end
    endgenerate

    // master is the total output = sum of all channels
    localparam MASTER_ACCUMULATOR_BITS = $clog2(NUM_CHANNELS) + CHANNEL_OUTPUT_BITS;
    localparam MASTER_MAX_OUTPUT_VOLUME = {MASTER_OUTPUT_BITS{1'b1}};
    wire master_overflow;
    wire [MASTER_ACCUMULATOR_BITS-1:0] master;
    assign { master_overflow, master } = volumes[0] + volumes[1] + volumes[2] + volumes[3]; // sum all channels
    assign raw_sample = 
        (master_overflow == 0) ? master[MASTER_ACCUMULATOR_BITS-1 -: MASTER_OUTPUT_BITS] :  // pass highest MASTER_OUTPUT_BITS to the DAC output pins
                                 MASTER_MAX_OUTPUT_VOLUME;                                  // ALSO prevent value wraparound in the master output
                                                                                            // in case of summation overflow clamp output to a maximum value

    wire [SPI_MASTER_OUTPUT_BITS-1:0] spi_master;
    assign spi_master = volumes[0] + volumes[1] + volumes[2] + volumes[3];

    // PWM outputs
    generate
        for (i = 0; i < NUM_CHANNELS; i = i + 1) begin
            pwm #(.VALUE_BITS(CHANNEL_OUTPUT_BITS)) pwm (
                .clk(clk),
                .reset(reset),
                .value(volumes[i]),
                .out(pwms[i])
                );
        end
    endgenerate

    pwm #(.VALUE_BITS(MASTER_ACCUMULATOR_BITS)) pwm (
        .clk(clk),
        .reset(reset),
        .value(master),
        .out(pwms[4])
        );

    spi_dac_i_2 spi_dac_i_2(
        .sample_in(spi_master),
        .clk(clk),
        .rst(reset),
        .spi_le(DAC_le),
        .spi_clk(DAC_clk),
        .spi_dat(DAC_dat),
        .sample_ready(1'b1)
    );
    
endmodule
