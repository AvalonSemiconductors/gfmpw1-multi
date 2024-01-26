TOOLCHAIN_ROOT = $(PWD)/../cross/bin
CC = $(TOOLCHAIN_ROOT)/pdp11-aout-gcc
LD = $(TOOLCHAIN_ROOT)/pdp11-aout-ld
AS = $(TOOLCHAIN_ROOT)/pdp11-aout-as
DUMPER = $(TOOLCHAIN_ROOT)/objdump

CCFLAGS += -O0 -g -std=gnu99 -m40 -Wall -c -nostdlib -ffreestanding
LDFLAGS += -nostdlib --strip-all -q -Ttext 0x00 --entry 0x00 -M

all: test

OBJS=test.o

%.o: %.c
	$(CC) $(CCFLAGS) -c -o $@ $<

crt0.o: crt0.s
	$(AS) -o crt0.o crt0.s

test:	crt0.o $(OBJS)
	$(LD) -o test $(LDFLAGS) $^ libgcc.a
	java ToVerilog.java test > test.txt

dump: test
	$(DUMPER) -D -x --target=binary -m pdp11 test.bin

clean:
	rm -rf *.o test

.PHONY: all
