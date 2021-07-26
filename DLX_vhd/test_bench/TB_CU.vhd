library IEEE;
use IEEE.std_logic_1164.all;
use work.myTypes.all;
-- *********** include file of all possible IWs

entity TB_CU is
end TB_CU;

architecture TEST of TB_CU is

	constant IR_SIZE : integer := 32;

	signal CK: std_logic;
	signal RST: std_logic;
	--instruction word:
	signal IW: std_logic_vector(IR_SIZE-1 downto 0);
	--control word:
	signal IR_LATCH_EN		:  std_logic;
	signal NPC_LATCH_EN		:  std_logic;
	signal RegA_LATCH_EN	:  std_logic;
	signal RegB_LATCH_EN	:  std_logic;
	signal RegIMM_LATCH_EN	:  std_logic;
	signal MUXA_SEL			:  std_logic;
	signal MUXB_SEL			:  std_logic;
	signal ALU_OUTREG_EN	:  std_logic;
	signal EQ_COND			:  std_logic;
	signal ALU_OPCODE		:  aluOpType;
	signal DRAM_WE			:  std_logic;
	signal D_LATCH_EN		:  std_logic;
	signal JUMP_EN			:  std_logic;
	signal PC_LATCH_EN 		:  std_logic;
	signal WB_MUX_SEL		:  std_logic;
	signal RF_WE			:  std_logic;
	
	constant CLOCK_CYCLE: time := 2 ns;
	constant INSTR_EXEC_TIME: time := 5*CLOCK_CYCLE; --remove the 5* if testing the pipeline *******

	component dlx_cu
			generic (
				MICROCODE_MEM_SIZE :     integer := 10;  -- Microcode Memory Size
				FUNC_SIZE          :     integer := 11;  -- Func Field Size for R-Type Ops
				OP_CODE_SIZE       :     integer := 6;  -- Op Code Size
				-- ALU_OPC_SIZE       :     integer := 6;  -- ALU Op Code Word Size
				IR_SIZE            :     integer := 32;  -- Instruction Register Size    
				CW_SIZE            :     integer := 15);  -- Control Word Size
			port (
				Clk                : in  std_logic;  -- Clock
				Rst                : in  std_logic;  -- Reset:Active-Low
				-- Instruction Register
				IR_IN              : in  std_logic_vector(IR_SIZE - 1 downto 0);
				
				-- IF Control Signal
				IR_LATCH_EN        : out std_logic;  -- Instruction Register Latch Enable
				NPC_LATCH_EN       : out std_logic;
													-- NextProgramCounter Register Latch Enable
				-- ID Control Signals
				RegA_LATCH_EN      : out std_logic;  -- Register A Latch Enable
				RegB_LATCH_EN      : out std_logic;  -- Register B Latch Enable
				RegIMM_LATCH_EN    : out std_logic;  -- Immediate Register Latch Enable

				-- EX Control Signals
				MUXA_SEL           : out std_logic;  -- MUX-A Sel
				MUXB_SEL           : out std_logic;  -- MUX-B Sel
				ALU_OUTREG_EN      : out std_logic;  -- ALU Output Register Enable
				EQ_COND            : out std_logic;  -- Branch if (not) Equal to Zero
				-- ALU Operation Code
				ALU_OPCODE         : out aluOpType;
				
				-- MEM Control Signals
				DRAM_WE            : out std_logic;  -- Data RAM Write Enable
				LMD_LATCH_EN       : out std_logic;  -- LMD Register Latch Enable
				JUMP_EN            : out std_logic;  -- JUMP Enable Signal for PC input MUX
				PC_LATCH_EN        : out std_logic;  -- Program Counte Latch Enable

				-- WB Control signals
				WB_MUX_SEL         : out std_logic;  -- Write Back MUX Sel
				RF_WE              : out std_logic);  -- Register File Write Enable
end component;

begin

	dut : dlx_cu
	generic map(MICROCODE_MEM_SIZE => 10,  -- Microcode Memory Size
				FUNC_SIZE => 11,  -- Func Field Size for R-Type Ops
				OP_CODE_SIZE => 6,  -- Op Code Size
				IR_SIZE => 32,  -- Instruction Register Size    
				CW_SIZE => 15)
	port map (CK, RST, IW, IR_LATCH_EN,
				NPC_LATCH_EN,
				RegA_LATCH_EN,
				RegB_LATCH_EN,
				RegIMM_LATCH_EN,
				MUXA_SEL,
				MUXB_SEL,
				ALU_OUTREG_EN,
				EQ_COND,
				ALU_OPCODE,
				DRAM_WE,
				D_LATCH_EN,
				JUMP_EN,
				PC_LATCH_EN,
				WB_MUX_SEL,
				RF_WE);
	
	process
	begin
		RST <= '0';
		wait for 5 ns;
		CK <= '1';
		wait for CLOCK_CYCLE/2;
		CK <= '0';
		wait for CLOCK_CYCLE/2;
	end process;


	process
	begin
	
	-- R-type OPCODE field
	IW(IW_SIZE-1 downto IW_SIZE-OP_CODE_SIZE) <= RTYPE;
	--IW(IW_SIZE-1 downto IW_SIZE-OPCODE_SIZE) <= FTYPE; -- for FP instructions
	
	-- R_type FUNC field
	IW(FUNC_SIZE-1 downto 0) <= RTYPE_ADD;
	wait for INSTR_EXEC_TIME;
	IW(FUNC_SIZE-1 downto 0) <= RTYPE_SUB;
	wait for INSTR_EXEC_TIME;
	IW(FUNC_SIZE-1 downto 0) <= RTYPE_AND;
	wait for INSTR_EXEC_TIME;
	IW(FUNC_SIZE-1 downto 0) <= RTYPE_OR;
	wait for INSTR_EXEC_TIME;
	IW(FUNC_SIZE-1 downto 0) <= RTYPE_SLE;
	wait for INSTR_EXEC_TIME;
	IW(FUNC_SIZE-1 downto 0) <= RTYPE_SGE;
	wait for INSTR_EXEC_TIME;
	IW(FUNC_SIZE-1 downto 0) <= RTYPE_SLL;
	wait for INSTR_EXEC_TIME;
	IW(FUNC_SIZE-1 downto 0) <= RTYPE_SRL;
	wait for INSTR_EXEC_TIME;
	IW(FUNC_SIZE-1 downto 0) <= RTYPE_SNE;
	wait for INSTR_EXEC_TIME;
	IW(FUNC_SIZE-1 downto 0) <= RTYPE_XOR;
	wait for INSTR_EXEC_TIME;
	
	
	-- I-type OPCODE field
	IW(IW_SIZE-1 downto IW_SIZE-OP_CODE_SIZE) <= ITYPE_ADDI;
	wait for INSTR_EXEC_TIME;
	IW(IW_SIZE-1 downto IW_SIZE-OP_CODE_SIZE) <= ITYPE_SUBI;
	wait for INSTR_EXEC_TIME;
	IW(IW_SIZE-1 downto IW_SIZE-OP_CODE_SIZE) <= ITYPE_ANDI;
	wait for INSTR_EXEC_TIME;
	IW(IW_SIZE-1 downto IW_SIZE-OP_CODE_SIZE) <= ITYPE_ORI;
	wait for INSTR_EXEC_TIME;
	IW(IW_SIZE-1 downto IW_SIZE-OP_CODE_SIZE) <= ITYPE_XORI;
	wait for INSTR_EXEC_TIME;
	IW(IW_SIZE-1 downto IW_SIZE-OP_CODE_SIZE) <= ITYPE_BEQZ;
	wait for INSTR_EXEC_TIME;
	IW(IW_SIZE-1 downto IW_SIZE-OP_CODE_SIZE) <= ITYPE_BNEZ;
	wait for INSTR_EXEC_TIME;
	IW(IW_SIZE-1 downto IW_SIZE-OP_CODE_SIZE) <= ITYPE_J;
	wait for INSTR_EXEC_TIME;
	IW(IW_SIZE-1 downto IW_SIZE-OP_CODE_SIZE) <= ITYPE_JAL;
	wait for INSTR_EXEC_TIME;
	IW(IW_SIZE-1 downto IW_SIZE-OP_CODE_SIZE) <= ITYPE_LW;
	wait for INSTR_EXEC_TIME;
	IW(IW_SIZE-1 downto IW_SIZE-OP_CODE_SIZE) <= ITYPE_SW;
	wait for INSTR_EXEC_TIME;
	IW(IW_SIZE-1 downto IW_SIZE-OP_CODE_SIZE) <= ITYPE_SLEI;
	wait for INSTR_EXEC_TIME;
	IW(IW_SIZE-1 downto IW_SIZE-OP_CODE_SIZE) <= ITYPE_SGEI;
	wait for INSTR_EXEC_TIME;
	IW(IW_SIZE-1 downto IW_SIZE-OP_CODE_SIZE) <= ITYPE_SLLI;
	wait for INSTR_EXEC_TIME;
	IW(IW_SIZE-1 downto IW_SIZE-OP_CODE_SIZE) <= ITYPE_SNEI;
	wait for INSTR_EXEC_TIME;
	IW(IW_SIZE-1 downto IW_SIZE-OP_CODE_SIZE) <= ITYPE_SRLI;
	wait for INSTR_EXEC_TIME;
	IW(IW_SIZE-1 downto IW_SIZE-OP_CODE_SIZE) <= ITYPE_NOP;
	wait for INSTR_EXEC_TIME;
	
	
	-- J-type
	
	end process;

end TEST;


