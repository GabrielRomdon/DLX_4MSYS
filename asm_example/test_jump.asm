addi r1,r0,#1
addi r2,r0,#31
nop
my_label:
nop
addi r1,r1,#1
nop
nop
nop
add r3,r1,r0
nop
nop
nop
subi r2,r2,#1
nop
nop
nop
nop
bnez r2,my_label
nop
nop
nop
beqz r0,my_label_dos
nop
nop
nop
my_label_dos:
nop
nop
nop
nop
nop
nop
j label_jump
nop
nop
nop
nop
nop
label_jump:
nop
nop
nop
nop
addi r4,r0,#184
nop
nop
nop
nop
nop
jal another_label_jump
nop
nop
nop
nop
nop
another_label_jump:
nop
nop
