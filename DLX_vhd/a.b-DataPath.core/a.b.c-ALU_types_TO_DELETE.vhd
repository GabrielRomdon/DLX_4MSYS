package alu_types is
	type TYPE_OP is (ADD, SUB, MULT, DIV, BITAND, BITOR, BITXOR, FUNCLSL, FUNCLSR, FUNCRL, FUNCRR, FUNCRL_B, FUNCRR_B);
end alu_types;

-- in this file we define the names of the operations that the ALU can perform. Based on the number N of possible operations the synthesizer will create log2(N) wires to control the ALU.
