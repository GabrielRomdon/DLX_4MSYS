library IEEE;
use IEEE.std_logic_1164.all;
use work.Log2.all;
use work.myTypes.all;

entity DataPath_BASIC is
	generic(N : integer := WORD;
		IMM_MAX : integer := MAX_IMM_SIZE;
		IR_SIZE : integer := IR_SIZE;
		RF_SIZE : integer := RF_SIZE;
		DRAM_SIZE : integer := DRAM_SIZE);
	port  ( CLK            : IN std_logic;
		      RST            : IN std_logic;  -- Low Reset
          IR_IN          : IN std_logic_vector(IR_SIZE-1 downto 0); -- Instruction word out from DP
		      
		      -- IF Control Signal
		      IR_LATCH_EN    : IN std_logic;  -- Instruction Register Latch Enable
		      NPC_LATCH_EN   : IN std_logic;  -- NextProgramCounter Register Latch Enable
		      
		      -- ID Control Signals
		      RegA_LATCH_EN  : IN std_logic;  -- Register A Latch Enable
		      RegB_LATCH_EN  : IN std_logic;  -- Register B Latch Enable
		      RegIMM_LATCH_EN: IN std_logic;  -- Immediate Register Latch Enable

		      -- EX Control Signals
		      SIGNED_IMM     : IN std_logic;  -- Extender sel, signed or unsigned immediate
		      MUXA_SEL       : IN std_logic;  -- MUX-A Sel
		      MUXB_SEL       : IN std_logic;  -- MUX-B Sel
		      ALU_OUTREG_EN  : IN std_logic;  -- ALU output Register Enable
		      EQ_COND        : IN std_logic;  -- Branch if (not) Equal to Zero
          IS_JUMP        : IN std_logic;  -- Take branch unconditionally
		      -- ALU Operation Code
		      ALU_OPCODE     : IN aluOpType; -- choose between implicit or exlicit coding, like std_logic_vector(ALU_OPC_SIZE -1 downto 0);
		      
		      -- MEM Control Signals
		      DRAM_WE        : IN std_logic;  -- Data RAM Write Enable
		      LMD_LATCH_EN   : IN std_logic;  -- LMD Register Latch Enable
		      JUMP_EN        : IN std_logic;  -- JUMP Enable Signal for PC input MUX
		      PC_LATCH_EN    : IN std_logic;  -- Program Counte Latch Enable

		      -- WB Control signals
		      IS_JAL         : IN std_logic;
		      WB_MUX_SEL     : IN std_logic;  -- Write Back MUX Sel
		      RF_WE          : IN std_logic;
		      
		      PC_IN			     : IN std_logic_vector(N-1 downto 0);
		      PC_BUS			   : OUT std_logic_vector(N-1 downto 0)); -- For PC out from DP, ie for Control Unit
end DataPath_BASIC;

architecture STRUCTURE of DataPath_BASIC is

component REG_GENERIC is -- generic register
	generic(NBIT: integer:= N);
	port( 	CLK:	IN std_logic;
			RST:	IN std_logic;
			EN:	IN std_logic;
			DATA_IN: IN std_logic_vector(NBIT-1 downto 0);
			DATA_OUT:	OUT std_logic_vector(NBIT-1 downto 0));
end component;

component MUX21 is
port( 	A: IN std_logic;
		B:	IN std_logic;
		SEL:	IN std_logic;
		Y:	OUT std_logic);
end component;

component MUX21_GENERIC is -- generic multiplexer
	generic(NBIT: integer:= N);
	port( 	A: IN std_logic_vector(NBIT-1 downto 0);
			B:	IN std_logic_vector(NBIT-1 downto 0);
			SEL:	IN std_logic;
			Y:	OUT std_logic_vector(NBIT-1 downto 0));
end component;
  
component BRANCHING_UNIT is
	generic(N: integer:= N);
	port  ( CLK            : IN std_logic;
		      RST            : IN std_logic;  -- Low Reset
          Reg_A: IN std_logic_vector(N-1 downto 0); -- from pipeline register A
			    EQ_cond: IN std_logic; -- 1 if BEQZ, 0 if BNEZ
          IS_JUMP: IN std_logic; -- 1 if the instruction is J type, 0 otherwise
			    branch_taken: OUT std_logic); -- 1 if branch is taken. 0 otherwise
end component;

component REGISTER_FILE is
	generic(NBIT: integer:= N;
		NREG: integer:= RF_SIZE);
    port (CLK: 		IN  std_logic;
	      RST: 	IN  std_logic;
	      EN: 	IN  std_logic;
	      RD1: 		IN  std_logic;
	      RD2: 		IN  std_logic;
	      WR: 		IN  std_logic;
	      ADD_WR: 	IN  std_logic_vector(Log2(NREG)-1 downto 0);
	      ADD_RD1: 	IN  std_logic_vector(Log2(NREG)-1 downto 0);
	      ADD_RD2: 	IN  std_logic_vector(Log2(NREG)-1 downto 0);
	      DATAIN: 	IN  std_logic_vector(NBIT-1 downto 0);
	      OUT1: 	OUT std_logic_vector(NBIT-1 downto 0);
	      OUT2: 	OUT std_logic_vector(NBIT-1 downto 0));
end component;

component MEMORY is
	generic(NBIT: integer:= N;
		SIZE: integer:= DRAM_SIZE);
    port (CLK: 		IN  std_logic;
	      RST: 		IN  std_logic;
	      EN: 		IN  std_logic;
	      RD: 		IN  std_logic;
	      WR: 		IN  std_logic;
	      ADDR: 	IN  std_logic_vector(Log2(SIZE)-1 downto 0);
	      DATA_IN: 	IN  std_logic_vector(NBIT-1 downto 0);
	      DATA_OUT: OUT std_logic_vector(NBIT-1 downto 0));
end component;

component ALU is
	generic(N: integer:= N);
  port   ( FUNC: IN aluOpType; -- Input for selecting the operation to be performed
           DATA1, DATA2: IN std_logic_vector(N-1 downto 0); -- Data inputs
           OUTALU: OUT std_logic_vector(N-1 downto 0)); -- Data outputs
end component;

component ADDER is -- specific adder to add 4 to the input
	generic(N: integer:= N);
  port   ( CURR_ADDR: IN std_logic_vector(N-1 downto 0); -- input address
           NEXT_ADDR: OUT std_logic_vector(N-1 downto 0)); -- output address(i.e. input address + 4)
end component;

component EXTENDER is
  generic (NBIT : integer := WORD;
	   IMM_MIN: integer := HALF_WORD;
	   IMM_MAX : integer := MAX_IMM_SIZE);
  port   ( NOT_EXT_IMM:     IN std_logic_vector(IMM_MAX-1 downto 0); -- input data
           SIGNED_IMM:      IN std_logic;
           IS_JUMP:         IN std_logic;
           EXT_IMM:         OUT std_logic_vector(NBIT-1 downto 0)); -- output data(i.e. input data with sign extension)
end component;

signal current_PC       : std_logic_vector(N-1 downto 0);
signal current_PC1      : std_logic_vector(N-1 downto 0);
signal current_PC2      : std_logic_vector(N-1 downto 0);
signal current_PC3      : std_logic_vector(N-1 downto 0);
signal next_PC          : std_logic_vector(N-1 downto 0);
signal current_NPC      : std_logic_vector(N-1 downto 0);
signal next_NPC         : std_logic_vector(N-1 downto 0);
signal current_IW       : std_logic_vector(N-1 downto 0);
signal WB1_IN           : std_logic_vector(Log2(RF_SIZE)-1 downto 0);
signal WB2_IN           : std_logic_vector(Log2(RF_SIZE)-1 downto 0);
signal WB2_OUT          : std_logic_vector(Log2(RF_SIZE)-1 downto 0);
signal WB3_OUT          : std_logic_vector(Log2(RF_SIZE)-1 downto 0);
signal WB_ADDR          : std_logic_vector(Log2(RF_SIZE)-1 downto 0);
signal A_IN             : std_logic_vector(N-1 downto 0);
signal B_IN             : std_logic_vector(N-1 downto 0);
signal IMM_IN           : std_logic_vector(IMM_MAX-1 downto 0);
signal A_OUT            : std_logic_vector(N-1 downto 0);
signal B_OUT            : std_logic_vector(N-1 downto 0);
signal B_OUT2           : std_logic_vector(N-1 downto 0);
signal IMM_OUT          : std_logic_vector(N-1 downto 0);
signal OUT_MUX_DATA     : std_logic_vector(N-1 downto 0);
signal WB_DATA          : std_logic_vector(N-1 downto 0);
signal ALU_OP1          : std_logic_vector(N-1 downto 0);
signal ALU_OP2          : std_logic_vector(N-1 downto 0);
signal next_ALU_OUT     : std_logic_vector(N-1 downto 0);
signal current_ALU_OUT  : std_logic_vector(N-1 downto 0);
signal current_ALU_OUT2 : std_logic_vector(N-1 downto 0);
signal next_RAM_OUT     : std_logic_vector(N-1 downto 0);
signal current_RAM_OUT  : std_logic_vector(N-1 downto 0);
signal PC_MUX_SEL       : std_logic;
signal branch_taken     : std_logic;

begin

PC_BUS <= next_PC;
current_PC <= next_PC when PC_LATCH_EN='1' else (others => '0');

-- registers:
PC_REG : REG_GENERIC
	generic map(N)
	port map(CLK => CLK, RST => RST, EN => PC_LATCH_EN, DATA_IN => PC_IN, DATA_OUT => current_PC1);
PC2_REG : REG_GENERIC
	generic map(N)
	port map(CLK => CLK, RST => RST, EN => PC_LATCH_EN, DATA_IN => current_PC1, DATA_OUT => current_PC2);
PC3_REG : REG_GENERIC
	generic map(N)
	port map(CLK => CLK, RST => RST, EN => PC_LATCH_EN, DATA_IN => current_PC2, DATA_OUT => current_PC3);

NPC_REG : REG_GENERIC
	generic map(N)
	port map(CLK => CLK, RST => RST, EN => NPC_LATCH_EN, DATA_IN => next_NPC, DATA_OUT => current_NPC);
	
IR_REG : REG_GENERIC
	generic map(N)
	port map(CLK => CLK, RST => RST, EN => IR_LATCH_EN, DATA_IN => IR_IN, DATA_OUT => current_IW);

IMM_REG : REG_GENERIC
	generic map(IMM_MAX)
	port map(CLK => CLK, RST => RST, EN => RegIMM_LATCH_EN, DATA_IN => current_IW(IMM_MAX-1 downto 0), DATA_OUT => IMM_IN);

WB1_REG : REG_GENERIC
	generic map(Log2(RF_SIZE))
	port map(CLK => CLK, RST => RST, EN => '1', DATA_IN => WB1_IN, DATA_OUT => WB2_IN);

WB2_REG : REG_GENERIC
	generic map(Log2(RF_SIZE))
	port map(CLK => CLK, RST => RST, EN => ALU_OUTREG_EN, DATA_IN => WB2_IN, DATA_OUT => WB2_OUT);

WB3_REG : REG_GENERIC
	generic map(Log2(RF_SIZE))
	port map(CLK => CLK, RST => RST, EN => '1', DATA_IN => WB2_OUT, DATA_OUT => WB3_OUT);

ALU_OUT_REG : REG_GENERIC
	generic map(N)
	port map(CLK => CLK, RST => RST, EN => ALU_OUTREG_EN, DATA_IN => next_ALU_OUT, DATA_OUT => current_ALU_OUT);

B_OUT_REG : REG_GENERIC
	generic map(N)
	port map(CLK => CLK, RST => RST, EN => ALU_OUTREG_EN, DATA_IN => B_OUT, DATA_OUT => B_OUT2);

ALU_OUT_REG2 : REG_GENERIC
	generic map(N)
	port map(CLK => CLK, RST => RST, EN => '1', DATA_IN => current_ALU_OUT, DATA_OUT => current_ALU_OUT2);

-- branching unit
BU: BRANCHING_UNIT
  generic map(N)
    port map(CLK => CLK, RST => RST, Reg_A => A_OUT, EQ_cond => EQ_COND, IS_JUMP => IS_JUMP, branch_taken => branch_taken);

-- multiplexers:
PC_MUX : MUX21_GENERIC
	generic map(N)
	port map(A => current_NPC, B => current_ALU_OUT, SEL => PC_MUX_SEL, Y => next_PC);

J_MUX : MUX21
	port map(A => '0', B => branch_taken, SEL => JUMP_EN, Y => PC_MUX_SEL);

RD_MUX : MUX21_GENERIC
	generic map(Log2(RF_SIZE))
	port map(A => current_IW(MSB_ADD_RD3 downto LSB_ADD_RD3), B => current_IW(MSB_ADD_RD2 downto LSB_ADD_RD2), SEL => RegIMM_LATCH_EN, Y => WB1_IN);

OP1_MUX : MUX21_GENERIC
	generic map(N)
	port map(A => A_OUT, B => current_PC1, SEL => MUXA_SEL, Y => ALU_OP1);
	
OP2_MUX : MUX21_GENERIC
	generic map(N)
	port map(A => B_OUT, B => IMM_OUT, SEL => MUXB_SEL, Y => ALU_OP2);
	
OUT_MUX : MUX21_GENERIC
	generic map(N)
	port map(A => current_RAM_OUT, B => current_ALU_OUT2, SEL => WB_MUX_SEL, Y => OUT_MUX_DATA);

JAL_DATA_MUX : MUX21_GENERIC
	generic map(N)
	port map(A => OUT_MUX_DATA, B => current_PC3, SEL => IS_JAL, Y => WB_DATA);

JAL_ADDR_MUX : MUX21_GENERIC
	generic map(Log2(RF_SIZE))
	port map(A => WB3_OUT, B => REG31, SEL => IS_JAL, Y => WB_ADDR);
-- adder for next PC computation:
PC_ADDER : ADDER
	generic map (N)
	port map ( CURR_ADDR => current_PC, NEXT_ADDR => next_NPC);

-- register file:
-- current_IW(26-1 downto 21) -> addr1
-- current_IW(21-1 downto 16) -> addr2
-- current_IW(16-1 downto 11) -> addr3
RF : REGISTER_FILE
    port map(CLK => CLK, RST => RST, EN => '1', RD1 => RegA_LATCH_EN, RD2 => RegB_LATCH_EN, WR => RF_WE, ADD_WR => WB_ADDR, ADD_RD1 => current_IW(MSB_ADD_RD1 downto LSB_ADD_RD1), ADD_RD2 => current_IW(MSB_ADD_RD2 downto LSB_ADD_RD2), DATAIN => WB_DATA, OUT1 => A_OUT, OUT2 => B_OUT);
	
-- immediate sign extension
EXT : EXTENDER
	port map(NOT_EXT_IMM => IMM_IN, SIGNED_IMM => SIGNED_IMM, IS_JUMP => IS_JUMP, EXT_IMM => IMM_OUT);

-- ALU:
ALU_i : ALU 
  port map(FUNC => ALU_OPCODE, DATA1 => ALU_OP1, DATA2 => ALU_OP2, OUTALU => next_ALU_OUT);
	
--data memory:
RAM : MEMORY
    port map(CLK => CLK, RST => RST, EN => '1', RD => LMD_LATCH_EN, WR => DRAM_WE, ADDR => current_ALU_OUT(Log2(DRAM_SIZE)-1 downto 0), DATA_IN => B_OUT2, DATA_OUT => current_RAM_OUT);

end STRUCTURE;
