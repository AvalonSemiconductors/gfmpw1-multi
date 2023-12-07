`default_nettype none

module wrapped_pdp11(
 // Required so LVS passes
`ifdef USE_POWER_PINS
  inout vdd,
  inout vss,
`endif
  input wb_clk_i, //Clock input
  input rst_n, //Active low
  input [32:0] io_in,
  output [32:0] io_out,
  output [32:0] io_oeb, //Output Enable Bar ; 0 = Output, 1 = Input
  input [19:0] custom_settings //Custom settings register, settable over mgmt controller firmware,
);

wire bus_oeb;
assign io_oeb[15:0] = {16{bus_oeb}};
assign io_oeb[19:16] = 4'h0;
assign io_out[17] = bus_oeb;
assign io_oeb[20] = 1'b0;

wire WEb;
assign io_out[19] = custom_settings[2:1] == 2'b01 ? WEb | wb_clk_i : (custom_settings[2:1] == 2'b10 ? WEb | (~wb_clk_i) : WEb);

wire [7:0] gpio_addr;
wire [15:0] gpio_out;
reg [15:0] gpio_in_buff;
wire gpio_wen;
wire [7:0] int_ack;
reg [7:0] irqs;

pdp11 pdp11(
  .clk(wb_clk_i),
  .rst_n(rst_n),
  .bus_out(io_out[15:0]),
  .bus_in(io_in[15:0]),
  .bus_oeb(bus_oeb),
  .latch_enable(io_out[16]),
  .OEb(io_out[18]),
  .WEb(WEb),

  .enable_map_psw(custom_settings[0]),
  .is_halted(io_out[20]),

  .int_reqs(irqs),
  .int_ack(int_ack),
  .io_addr(gpio_addr),
  .io_out(gpio_out),
  .io_in(gpio_in_buff),
  .io_wen(gpio_wen),

  .illegal_trap_enable(custom_settings[3]),
  .start_addr(custom_settings[18:4]),
  .trace_trap_enable(custom_settings[19])
);

/*
 * I/O Device Stuff
 */

reg [6:0] DDRA;
reg [6:0] PORTA;
assign io_out[32:26] = PORTA;
assign io_oeb[32:26] = ~DDRA;
reg [4:0] PORTA_ints;
reg [4:0] last_ints;

reg [15:0] tmr0;
reg [15:0] tmr1;
reg [15:0] tmr0_pre;
reg [15:0] tmr1_pre;
reg [15:0] tmr0_pre_ctr;
reg [15:0] tmr1_pre_ctr;
reg [15:0] tmr0_top;
reg [15:0] tmr1_top;
reg [1:0] tmr_int_ens;
reg uart_int_en;

always @(posedge wb_clk_i) begin
  if(!rst_n) begin
    gpio_in_buff <= 0;
    DDRA <= 0;
    PORTA <= 0;
    PORTA_ints <= 0;
    irqs <= 0;
    last_ints <= 5'h1F;
    tmr0 <= 0;
    tmr1 <= 0;
    tmr0_pre <= 16;
    tmr1_pre <= 32;
    tmr0_pre_ctr <= 0;
    tmr1_pre_ctr <= 0;
    tmr0_top <= 16'h8000;
    tmr1_top <= 16'h8000;
    tmr_int_ens <= 0;
    uart_int_en <= 0;
  end else begin
    if(!last_ints[0] && io_in[26]) irqs[0] <= 1'b1;
    else irqs[0] <= irqs[0] & ~int_ack[0];
    if(!last_ints[1] && io_in[27]) irqs[2] <= 1'b1;
    else irqs[2] <= irqs[2] & ~int_ack[2];
    if(!last_ints[2] && io_in[28]) irqs[4] <= 1'b1;
    else irqs[4] <= irqs[4] & ~int_ack[4];
    if(!last_ints[3] && io_in[29]) irqs[6] <= 1'b1;
    else irqs[6] <= irqs[6] & ~int_ack[6];
    if(!last_ints[4] && io_in[30]) irqs[7] <= 1'b1;
    else irqs[7] <= irqs[7] & ~int_ack[7];
    last_ints <= io_in[30:26] | (~PORTA_ints);

    irqs[1] <= irqs[1] & ~int_ack[1];
    irqs[5] <= irqs[5] & ~int_ack[5];
    irqs[3] <= (irqs[3] & ~int_ack[3]) || (uart_has_byte && uart_int_en);
    tmr0_pre_ctr <= tmr0_pre_ctr + 1;
    tmr1_pre_ctr <= tmr0_pre_ctr + 1;
    if((tmr0_pre_ctr+1) >= tmr0_pre) begin
      tmr0_pre_ctr <= 0;
      tmr0 <= tmr0 + 1;
      if(tmr0 >= tmr0_top) begin
        tmr0 <= 0;
        irqs[1] <= tmr_int_ens[0];
      end
    end
    if((tmr1_pre_ctr+1) >= tmr1_pre) begin
      tmr1_pre_ctr <= 0;
      tmr1 <= tmr1 + 1;
      if(tmr1 >= tmr1_top) begin
        tmr1 <= 0;
        irqs[5] <= tmr_int_ens[1];
      end
    end

    case(gpio_addr)
      default: begin
        if(!gpio_wen) gpio_in_buff <= 16'hFFFF;
      end
      0: begin
        if(gpio_wen) DDRA <= gpio_out[6:0];
        else gpio_in_buff <= {9'h000, DDRA};
      end
      1: begin
        if(gpio_wen) PORTA <= gpio_out[6:0];
        else gpio_in_buff <= {9'h000, PORTA};
      end
      2: begin
        if(!gpio_wen) gpio_in_buff <= {9'h000, io_in[32:26]};
      end
      3: begin
        if(gpio_wen) PORTA_ints <= gpio_out[4:0];
        else gpio_in_buff <= {10'h000, PORTA_ints};
      end
      4: begin
        if(gpio_wen) tmr0_pre <= gpio_out;
        else gpio_in_buff <= tmr0_pre;
      end
      5: begin
        if(gpio_wen) tmr1_pre <= gpio_out;
        else gpio_in_buff <= tmr1_pre;
      end
      6: begin
        if(gpio_wen) tmr0_top <= gpio_out;
        else gpio_in_buff <= tmr0_top;
      end
      7: begin
        if(gpio_wen) tmr1_top <= gpio_out;
        else gpio_in_buff <= tmr1_top;
      end
      8: begin
        if(gpio_wen) tmr0 <= gpio_out;
        else gpio_in_buff <= tmr0;
      end
      9: begin
        if(gpio_wen) tmr1 <= gpio_out;
        else gpio_in_buff <= tmr1;
      end
      10: begin
        if(gpio_wen) tmr_int_ens <= gpio_out[1:0];
        else gpio_in_buff <= {14'h0A00, tmr_int_ens};
      end
      11: begin
        if(gpio_wen) spi_div <= gpio_out[7:0];
        else gpio_in_buff <= {8'h00, spi_div};
      end
      12: begin
        if(!gpio_wen) gpio_in_buff <= {8'h00, spi_dout};
      end
      13: begin
        if(!gpio_wen) gpio_in_buff <= {8'h00, spi_busy, spi_busy, spi_busy, spi_busy, spi_busy, spi_busy, spi_busy, spi_busy};
      end
      14: begin
        if(gpio_wen) uart_div <= gpio_out;
        else gpio_in_buff <= gpio_out;
      end
      15: begin
        if(!gpio_wen) gpio_in_buff <= {8'h00, uart_dout};
      end
      16: begin
        if(!gpio_wen) gpio_in_buff <= {8'h00, uart_busy, uart_busy, uart_busy, uart_busy, uart_busy, uart_busy, uart_busy, uart_busy};
      end
    endcase
  end
end

reg [7:0] spi_div;
wire [7:0] spi_dout;
wire spi_busy;
assign io_oeb[21] = 1'b0;
assign io_oeb[22] = 1'b0;
assign io_oeb[23] = 1'b1;
assign io_out[23] = 1'b0;
qcpu_spi qcpu_spi(
  .divisor(spi_div),
  .din(gpio_out[7:0]),
  .dout(spi_dout),
  .SCLK(io_out[21]),
  .DO(io_out[22]),
  .DI(io_in[23]),
  .start(gpio_wen && gpio_addr == 12 && !spi_busy),
  .busy(spi_busy),
  .clk(wb_clk_i),
  .rst(!rst_n)
);

reg [15:0] uart_div;
wire [7:0] uart_dout;
wire uart_busy;
wire uart_has_byte;

assign io_oeb[24] = 1'b0;
assign io_oeb[25] = 1'b1;
assign io_out[25] = 1'b0;
qcpu_uart qcpu_uart(
  .divisor(uart_div),
  .din(gpio_out[7:0]),
  .dout(uart_dout),
  .TX(io_out[24]),
  .RX(io_in[25]),
  .start(gpio_wen && gpio_addr == 15 && !uart_busy),
  .busy(uart_busy),
  .has_byte(uart_has_byte),
  .clr_hb(int_ack[3] || (gpio_wen && gpio_addr == 16)),
  .clk(wb_clk_i),
  .rst(!rst_n)
);

endmodule
