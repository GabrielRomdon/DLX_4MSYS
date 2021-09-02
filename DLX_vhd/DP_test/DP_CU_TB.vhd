library IEEE;
use IEEE.std_logic_1164.all;
use work.Log2.all;
use work.myTypes.all;

entity DP_CU_TB is
end DP_CU_TB;

architecture test of DP_CU_TB is

constant N : integer := 32;

component DP_CU is
	generic(N : integer := numBit;
			IR_SIZE : integer := 32);
	port(	CLK_DP: IN std_logic;
			CLK_CU: IN std_logic;
			RST: IN std_logic;
			IR: IN std_logic_vector(IR_SIZE-1 downto 0);
			PC: OUT std_logic_vector(N-1 downto 0));
end component;

signal CLK_DP_TB : std_logic := '0';
signal CLK_CU_TB : std_logic := '0';
signal RST_TB : std_logic := '1'; --active high reset
signal IR_TB: std_logic_vector(IR_SIZE-1 downto 0);
signal PC_TB: std_logic_vector(N-1 downto 0);

constant CLOCK_CYCLE: time := 1 ns;
constant INSTR_EXEC_TIME: time := 5*CLOCK_CYCLE; --remove the 5* if testing the pipeline *******

begin

dut : DP_CU
	generic map(32)
	port map(CLK_DP => CLK_DP_TB, CLK_CU => CLK_CU_TB, RST => RST_TB, IR => IR_TB, PC => PC_TB);

DP_PCLOCK : process(CLK_DP_TB)
begin
	CLK_DP_TB <= not(CLK_DP_TB) after 0.5 ns;	
end process;

CU_PCLOCK : process(CLK_CU_TB)
begin
	CLK_CU_TB <= not(CLK_CU_TB) after 0.5 ns;	
end process;

RST_TB <= '0' after 1.3 ns;

-- IR test cases:
process
	begin

	--operands for the R type instructions
	IR_TB(IR_SIZE-OP_CODE_SIZE-1 downto IR_SIZE-OP_CODE_SIZE-5) <= "00001";
	IR_TB(IR_SIZE-OP_CODE_SIZE-5-1 downto IR_SIZE-OP_CODE_SIZE-5-5) <= "00010";
	IR_TB(IR_SIZE-OP_CODE_SIZE-5-5-1 downto IR_SIZE-OP_CODE_SIZE-5-5-5) <= "00011";
	
	-- R-type OPCODE field
	IR_TB(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= RTYPE;
	--IR_TB(IR_SIZE-1 downto IR_SIZE-OPCODE_SIZE) <= FTYPE; -- for FP instructions
	
	-- R_type FUNC field
	IR_TB(FUNC_SIZE-1 downto 0) <= RTYPE_ADD;
	wait for INSTR_EXEC_TIME;
	IR_TB(FUNC_SIZE-1 downto 0) <= RTYPE_SUB;
	wait for INSTR_EXEC_TIME;
	IR_TB(FUNC_SIZE-1 downto 0) <= RTYPE_AND;
	wait for INSTR_EXEC_TIME;
	IR_TB(FUNC_SIZE-1 downto 0) <= RTYPE_OR;
	wait for INSTR_EXEC_TIME;
	IR_TB(FUNC_SIZE-1 downto 0) <= RTYPE_SLE;
	wait for INSTR_EXEC_TIME;
	IR_TB(FUNC_SIZE-1 downto 0) <= RTYPE_SGE;
	wait for INSTR_EXEC_TIME;
	IR_TB(FUNC_SIZE-1 downto 0) <= RTYPE_SLL;
	wait for INSTR_EXEC_TIME;
	IR_TB(FUNC_SIZE-1 downto 0) <= RTYPE_SRL;
	wait for INSTR_EXEC_TIME;
	IR_TB(FUNC_SIZE-1 downto 0) <= RTYPE_SNE;
	wait for INSTR_EXEC_TIME;
	IR_TB(FUNC_SIZE-1 downto 0) <= RTYPE_XOR;
	wait for INSTR_EXEC_TIME;
	
	
	-- I-type OPCODE field
	IR_TB(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_ADDI;
	wait for INSTR_EXEC_TIME;
	IR_TB(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_SUBI;
	wait for INSTR_EXEC_TIME;
	IR_TB(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_ANDI;
	wait for INSTR_EXEC_TIME;
	IR_TB(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_ORI;
	wait for INSTR_EXEC_TIME;
	IR_TB(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_XORI;
	wait for INSTR_EXEC_TIME;
	IR_TB(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_BEQZ;
	wait for INSTR_EXEC_TIME;
	IR_TB(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_BNEZ;
	wait for INSTR_EXEC_TIME;
	IR_TB(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_J;
	wait for INSTR_EXEC_TIME;
	IR_TB(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_JAL;
	wait for INSTR_EXEC_TIME;
	IR_TB(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_LW;
	wait for INSTR_EXEC_TIME;
	IR_TB(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_SW;
	wait for INSTR_EXEC_TIME;
	IR_TB(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_SLEI;
	wait for INSTR_EXEC_TIME;
	IR_TB(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_SGEI;
	wait for INSTR_EXEC_TIME;
	IR_TB(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_SLLI;
	wait for INSTR_EXEC_TIME;
	IR_TB(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_SNEI;
	wait for INSTR_EXEC_TIME;
	IR_TB(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_SRLI;
	wait for INSTR_EXEC_TIME;
	IR_TB(IR_SIZE-1 downto IR_SIZE-OP_CODE_SIZE) <= ITYPE_NOP;
	wait for INSTR_EXEC_TIME;
	
	
	-- J-type
	
	end process;




end test;
