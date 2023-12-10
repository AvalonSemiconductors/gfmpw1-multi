#include <stdint.h>

#define IO_BASE 0x400000
#define IO_EMU_PRINT 12

#define IO_IN(port)       *(volatile uint32_t*)(IO_BASE + port)
#define IO_OUT(port,val)  *(volatile uint32_t*)(IO_BASE + port)=(val)
