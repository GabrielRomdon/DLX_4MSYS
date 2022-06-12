init:
addi r1,r0,#2
ori r2,r0,#7
slei r3,r0,#6
subi r4,r0,#-10
sw 10(r0),r1
sgei r5,r1,#64
add r31,r1,r1
label:
srli r2,r2,#1
xori r4,r3,#45000
addi r16,r0,#4500
add r1,r3,r1
beqz r2, label
nop
nop
nop
jal end
nop
nop
nop
not_done:
sub r6,r4,r31
sw 16(r0), r16
end:
and r6, r4, r16
slli r31,r31,#10
lw r20, 10(r0)
j init
nop
nop
nop
