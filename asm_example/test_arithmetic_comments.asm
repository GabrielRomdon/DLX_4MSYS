addi r1,r0,#2	# r1 = 2
subi r2,r1,#1	# r2 = 1
addi r3,r1,#-4	# r3 = -2
subi r4,r3,#-1	# r4 = -1
add r7,r1,r2	# r7 = 3
sub r8,r5,r6	# r8 = 3
sge r10,r1,r2	# r10= 1
sge r10,r2,r1	# r10= 0
sge r10,r1,r1	# r10= 1
sle r10,r1,r2	# r10= 0
sle r10,r2,r1	# r10= 1
sle r10,r1,r1	# r10= 1
sne r10,r1,r1	# r10= 0
sne r10,r1,r2	# r10= 1
sgei r10,r1,#4	# r10= 0
sgei r10,r1,#1	# r10= 1
slei r10,r1,#0	# r10= 0
slei r10,r1,#2	# r10= 1
snei r10,r1,#1	# r10= 1
snei r10,r1,#2	# r10= 0
or r13,r11,r12
ori r14,r12,#65535
and r15,r14,r2
andi r16,r14,#1
sll r17,r16,r2
slli r18,r16,#1
srl r19,r16,r2
srli r20,r16,#1
xor r24,r1,r1
xori r25,r1,#2
