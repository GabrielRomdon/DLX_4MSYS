init:
	addi r1,r0,#1
	addi r2,r0,#10
	subi r3,r0,#2
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
	j next
	nop
	nop
	nop

try:
	subi r3,r3,#-2
	nop
	nop
	nop

next:
	beqz r3,end
	nop
	nop
	nop
	jal try
	nop
	nop
	nop

notdone:
	addi r4,r0,#128
	jal #164

end:
	addi r5,r0,#5
