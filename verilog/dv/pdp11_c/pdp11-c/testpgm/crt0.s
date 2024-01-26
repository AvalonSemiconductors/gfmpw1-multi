#NO_APP
gcc_compiled:
.text
	.align 2
.globl _start
_start:
	nop
#APP
#
	clr sp
	dec sp
	dec sp
	dec sp
	dec sp
	jsr pc, _main
#NO_APP
L1:
	nop
hlt:
	jmp hlt
	.align 2
#does nothing
.globl ___main
___main:
	rts pc

.globl _exit
_exit:
	jmp _exit
	rts pc
