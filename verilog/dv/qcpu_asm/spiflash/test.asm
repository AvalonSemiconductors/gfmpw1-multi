start:
	j main
int_vec:
	rti
trup_vec:
	j trupt
main:
	ioa r0
	ldi r1,#$FF
	out r1
	ioa #$01
	out r0
	nop
	ioa #$0C
	ldi r1,#$05
	out r1
	ioa #$11
	ldi r1,#$88
	out r1
	ioa #$12
	out r0
	ldi r3,#$08
	pf r3
	st r0,r0(0)
	ldi r2,#$3F
	
	j *-1

trupt:
	st r1,r2(0)
	sub r2,#1
	
	ld r1,r0(0)
	add r1,#1
	st r1,r0(0)
	cmp r1,#10
	bc exit_sim
	
	add r2,#1
	ld r1,r2(0)
	rti

exit_sim:
	ioa #$00
	ldi r1,#$FF
	out r1
	ioa #$01
	ldi r1,#$55
	out r1
	j exit_sim
