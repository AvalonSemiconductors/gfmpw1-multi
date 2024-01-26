TOOLCHAIN_ROOT = $(PWD)/../cross/bin
CC = $(TOOLCHAIN_ROOT)/pdp11-aout-gcc
LD = $(TOOLCHAIN_ROOT)/pdp11-aout-ld
AS = $(TOOLCHAIN_ROOT)/pdp11-aout-as
DUMPER = $(TOOLCHAIN_ROOT)/pdp11-aout-objdump

LDFLAGS += -nostdlib --strip-all -Ttext 0x0 --entry 0x00 -M

all: test

test.o: test.s
	$(AS) -o test.o test.s

test:	test.o
	$(LD) -o test $(LDFLAGS) test.o
	java ToVerilog.java test > test.txt

dump: test
	$(DUMPER) -D -x --target=binary -m pdp11 test.bin

clean:
	 rm -rf *.o test

.PHONY: all echo clean
