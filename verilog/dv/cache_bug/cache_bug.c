#include "defs.h"

#define reg_mprj_proj_sel (*(volatile uint32_t*)0x30080000)
#define reg_mprj_counter (*(volatile uint32_t*)0x30040000)
#define reg_mprj_settings (*(volatile uint32_t*)0x30020000)
#define reg_mprj_sram ((volatile uint32_t*)0x30010000)

static const char hexchars[] = "0123456789ABCDEF";

int putchar(int c) {
	reg_uart_data = c;
	while(reg_uart_txfull == 1);
	return c;
}

void puthex(uint32_t ui) {
	reg_mprj_datah = reg_mprj_datal = ui;
	for(uint8_t i = 0; i < 8; i++) {
		uint8_t x = (uint8_t)(ui >> 28);
		putchar(hexchars[x]);
		ui <<= 4;
	}
}

void configure_io() {
	reg_mprj_io_0 = GPIO_MODE_MGMT_STD_INPUT_NOPULL;
	reg_mprj_io_1 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_2 = GPIO_MODE_MGMT_STD_INPUT_NOPULL;
	reg_mprj_io_3 = GPIO_MODE_MGMT_STD_INPUT_NOPULL;
	reg_mprj_io_4 = GPIO_MODE_MGMT_STD_INPUT_NOPULL;
	reg_mprj_io_5 = GPIO_MODE_MGMT_STD_INPUT_NOPULL;     // UART Rx
	reg_mprj_io_6 = GPIO_MODE_MGMT_STD_OUTPUT;           // UART Tx
	reg_mprj_io_7 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_8 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_9 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_10 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_11 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_12 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_13 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_14 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_15 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_16 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_17 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_18 = GPIO_MODE_MGMT_STD_OUTPUT;

	reg_mprj_io_19 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_20 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_21 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_22 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_23 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_24 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_25 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_26 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_27 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_28 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_29 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_30 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_31 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_32 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_33 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_34 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_35 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_36 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_37 = GPIO_MODE_MGMT_STD_OUTPUT;
	
	reg_mprj_datah = 0;
	reg_mprj_datal = 0;

	reg_mprj_xfer = 1;
	while (reg_mprj_xfer == 1);
}

void delay(const int d) {
	reg_timer0_config = 0;
	reg_timer0_data = d;
	reg_timer0_config = 1;
	reg_timer0_update = 1;
	while (reg_timer0_value > 0) reg_timer0_update = 1;
}

volatile uint32_t variable;

void main() {
    reg_gpio_mode1 = 1;
    reg_gpio_mode0 = 0;
    reg_gpio_ien = 1;
    reg_gpio_oeb = 0;
    reg_gpio_out = 1;

	variable = 0x12345678;
    configure_io();
	reg_gpio_out = 0;
	reg_uart_enable = 1;
	reg_wb_enable = 1;

	reg_la0_oenb = reg_la0_iena = 0x00000000;    // [31:0]
	reg_la1_oenb = reg_la1_iena = 0x00000000;    // [63:32]
	reg_la2_oenb = reg_la2_iena = 0x00000000;    // [95:64]
	reg_la3_oenb = reg_la3_iena = 0x00000000;    // [127:96]
	
	variable = 0x00085003;
	reg_mprj_settings = 1; //This is the wishbone access that causes the previous memory write to be dropped
	//Theoretically, this should print the same thing twice. Not like the variable is being changed, right?
	//Actually, it’ll print "00000000" (garbage value) followed by "00085003" (the variable’s intended value).
	puthex(variable); putchar('\n');
	puthex(variable); putchar('\n');
	while(reg_uart_txfull == 1);
	reg_gpio_out = 1;
	
	while(1) {
        reg_gpio_out = 1; // OFF
		delay(2000000);
        reg_gpio_out = 0;  // ON
		delay(500000);
    }
}
