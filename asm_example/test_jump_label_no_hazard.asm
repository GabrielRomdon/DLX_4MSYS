init:
	addi r1,r0,#1
	addi r2,r0,#31
	nop
	nop
	nop

loop:
	slli r1,r1,#1
	subi r2,r2,#1
	nop
	nop
	nop
	bnez r2,loop
	nop
	nop
	nop

next:
	beqz r0,#2
	j end
	nop
	nop
	nop

notdone:
	addi r4,r0,#128
	jr r4
	jal #164
	jalr r31

end:
	add r2,r0,r0