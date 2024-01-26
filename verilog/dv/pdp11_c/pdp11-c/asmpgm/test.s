.org 0
.globl _start
_start:
	nop
	nop
	nop
	nop
	mov $372, R0
	mov $3768, R1
	mov R0, 0
	mov R1, 2
	mul R1, R0
	mov R0, 4
	mov R1, 6
	mov $32, R3
	div R3, R0
	mov R3, 8
	mov R0, 10
	mov R1, 12
	halt
