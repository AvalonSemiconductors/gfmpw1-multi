#include <stdint.h>
#include <stdarg.h>
#include <stdbool.h>

#include "io.h"
#include "tholinstd.h"

int putchar(int c) {
	IO_OUT(IO_EMU_PRINT, c);
	return 0;
}

float absd(float x) {
	if(x < 0) return -x;
	return x;
}

volatile uint32_t* spi_div = (volatile uint32_t*)0xFFFFFF00;
volatile uint32_t* spi_dat = (volatile uint32_t*)0xFFFFFF04;
volatile uint32_t* PORT_dir = (volatile uint32_t*)0xFFFFFF14;
volatile uint32_t* PORT_out = (volatile uint32_t*)0xFFFFFF18;
volatile uint32_t* chirp_1 = (volatile uint32_t*)0xFFFFFF4C;
volatile uint32_t* chirp_2 = (volatile uint32_t*)0xFFFFFF50;

void main(void) {
	puts("Hello from Tholin’s RISC-V Core!\r\n");
	*PORT_dir = 0xFF;
	*PORT_out = 0x55;
	*spi_div = 7;
	*spi_dat = 0x6C;
	uint32_t a = *chirp_1;
	putchar(a & 0xFF);
	putchar((a >> 8) & 0xFF);
	putchar((a >> 16) & 0xFF);
	putchar((a >> 24) & 0xFF);
	a = *chirp_2;
	putchar(a & 0xFF);
	putchar((a >> 8) & 0xFF);
	puts("\r\n");
	printf("ab%c %d \"%s\" hex=%x unsigned=%u\n", 'c', 219581, "another string", 219582, 3070660541U);
	printf("longs: %ld hex=%lx unsigned=%lu\n", 2704080616701578000UL, 2704080616701578001UL, 17137082711761398313UL);
	float ratio1,ratio2;
	long fiba,fibb,t;
	float epsilon;
	int fibCntr;
	fiba = 1;
	fibb = 1;
	epsilon = 1e-32;
	fibCntr = 0;
	printf("Aproximating golden ratio\n");
	while(1) {
		putchar('-');
		fibCntr++;
		t = fiba;
		fiba = fibb;
		fibb = fiba + t;
		ratio1 = (float)fibb / (float)fiba;
		ratio2 = (float)(fiba + fibb) / (float)fibb;
		if(absd(ratio1 - ratio2) < epsilon) break;
	}
	printf("\r\n%d\r\n", (int)(ratio1 * 1000));
	printf("%d\r\n", fibCntr);
	IO_OUT(IO_EMU_PRINT+12, 1);
	while(1);
}
