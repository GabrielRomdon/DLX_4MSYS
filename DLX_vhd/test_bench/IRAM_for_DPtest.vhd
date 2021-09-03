library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.Log2.all; -- for using the log2 algo, in order to compute the number of bits needed to Address the registers
use work.myTypes.all;

entity IRAM is
  generic (
    RAM_DEPTH : integer := 48;
    I_SIZE : integer := 32);
  port (
    Rst  : in  std_logic;
    Addr : in  std_logic_vector(I_SIZE - 1 downto 0);
    Dout : out std_logic_vector(I_SIZE - 1 downto 0)
    );
end IRAM;

architecture BEHAVIOR of IRAM is

	subtype MEM_ADDR is natural range 0 to RAM_DEPTH-1;
	type MEM_ARRAY is array(MEM_ADDR) of std_logic_vector(I_SIZE-1 downto 0);
	signal INSTRUCTIONS : MEM_ARRAY;-- this is the signal that will represent the whole instruction memory
begin 
process
begin
	--operands for the R type instructions
	for i in 0 to RAM_DEPTH-1 loop
		INSTRUCTIONS(i)(IR_SIZE-OP_CODE_SIZE-1 downto IR_SIZE-OP_CODE_SIZE-5) <= "00001"; 
		INSTRUCTIONS(i)(IR_SIZE-OP_CODE_SIZE-5-1 downto IR_SIZE-OP_CODE_SIZE-5-5) <= "00010";
		INSTRUCTIONS(i)(IR_SIZE-OP_CODE_SIZE-5-5-1 downto IR_SIZE-OP_CODE_SIZE-5-5-5) <= "00011";
	end loop;
	
	for i in 0 to 9 loop
		-- R-type OPCODE field
		INSTRUCTIONS(i)(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= RTYPE;
	end loop;

end process;
	
	-- R_type FUNC field
	INSTRUCTIONS(0)(FUNC_SIZE-1 downto 0) <= RTYPE_ADD;
	INSTRUCTIONS(1)(FUNC_SIZE-1 downto 0) <= RTYPE_SUB;
	INSTRUCTIONS(2)(FUNC_SIZE-1 downto 0) <= RTYPE_AND;
	INSTRUCTIONS(3)(FUNC_SIZE-1 downto 0) <= RTYPE_OR;
	INSTRUCTIONS(4)(FUNC_SIZE-1 downto 0) <= RTYPE_SLE;
	INSTRUCTIONS(5)(FUNC_SIZE-1 downto 0) <= RTYPE_SGE;
	INSTRUCTIONS(6)(FUNC_SIZE-1 downto 0) <= RTYPE_SLL;
	INSTRUCTIONS(7)(FUNC_SIZE-1 downto 0) <= RTYPE_SRL;
	INSTRUCTIONS(8)(FUNC_SIZE-1 downto 0) <= RTYPE_SNE;
	INSTRUCTIONS(9)(FUNC_SIZE-1 downto 0) <= RTYPE_XOR;

	
	-- I-type OPCODE field
	INSTRUCTIONS(10)(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_ADDI;
	INSTRUCTIONS(11)(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_SUBI;
	INSTRUCTIONS(12)(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_ANDI;
	INSTRUCTIONS(13)(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_ORI;
	INSTRUCTIONS(14)(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_XORI;
	INSTRUCTIONS(15)(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_BEQZ;
	INSTRUCTIONS(16)(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_BNEZ;
	INSTRUCTIONS(17)(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_J;
	INSTRUCTIONS(18)(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_JAL;
	INSTRUCTIONS(19)(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_LW;
	INSTRUCTIONS(20)(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_SW;
	INSTRUCTIONS(21)(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_SLEI;
	INSTRUCTIONS(22)(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_SGEI;
	INSTRUCTIONS(23)(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_SLLI;
	INSTRUCTIONS(24)(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_SNEI;
	INSTRUCTIONS(25)(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_SRLI;
	INSTRUCTIONS(26)(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_NOP;

process (Addr)
begin
		Dout <= INSTRUCTIONS(to_integer(unsigned(Addr)));
end process;
  
end BEHAVIOR;
