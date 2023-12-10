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

void main(void) {
	puts("Hello from Tholin’s RISC-V Core!\r\n");
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
