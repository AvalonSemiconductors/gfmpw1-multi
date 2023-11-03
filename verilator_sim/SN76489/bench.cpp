#include "Vtb.h"
#include "verilated.h"
#include <iostream>
#include <fstream>

static Vtb top;

void clocks(int c) {
	for(int i = 0; i < c*2; i++) {
		Verilated::timeInc(1);
		top.clk = !top.clk;
		top.eval();
		if(Verilated::gotFinish()) return;
	}
}

void reg_write(int val) {
	top.data = val;
	clocks(1);
	top.WEb = 0;
	clocks(2);
	top.WEb = 1;
	clocks(2);
}

void wait_secs(int secs) {
	float cycs = secs * 44100 * 45.35f;
	clocks((int)cycs);
}

int main(int argc, char** argv, char** env) {
#ifdef TRACE_ON
	printf("Warning: tracing is ON!\r\n");
	Verilated::traceEverOn(true);
#endif
	top.rst_n = 0;
	top.WEb = 1;
	clocks(2);
	top.rst_n = 1;
	clocks(24);
	reg_write(0b10000000);
	reg_write(0b00001100);
	reg_write(0b10010000);
	wait_secs(1);
	reg_write(0b10100000);
	reg_write(0b00000110);
	reg_write(0b10110000);
	wait_secs(1);
	reg_write(0b11000000);
	reg_write(0b00011000);
	reg_write(0b11010000);
	wait_secs(1);
	reg_write(0b11100110);
	reg_write(0b11110001);
	wait_secs(1);
	
	top.final();
}
