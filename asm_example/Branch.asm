
addi r1, r0, 10
xor r2, r2, r2

ciclo:
lw r3, 0(r2)
addi r3, r2, 10
nop
nop
nop
nop
sw 10(r4), r3
subi r1, r1, 1
addi r2, r2, 4
nop
nop
nop
bnez r1, ciclo
nop
nop
addi r4, r0, 65535 
nop
nop
nop
ori r5, r4, 100000
nop
nop
nop
add r6, r4, r5
end:
j end
