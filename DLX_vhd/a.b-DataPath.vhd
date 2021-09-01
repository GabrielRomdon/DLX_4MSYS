library IEEE;
use IEEE.std_logic_1164.all;
use work.Log2.all;
use work.myTypes.all;

entity DataPath_BASIC is
	generic(N : integer := numBit);
	port(	CLK: IN std_logic;
			RST: IN std_logic;
			
			-- IF Control Signal
			IR_LATCH_EN        : IN std_logic;  -- Instruction Register Latch Enable
			NPC_LATCH_EN       : IN std_logic;  -- NextProgramCounter Register Latch Enable
			
			-- ID Control Signals
			RegA_LATCH_EN      : IN std_logic;  -- Register A Latch Enable
			RegB_LATCH_EN      : IN std_logic;  -- Register B Latch Enable
			RegIMM_LATCH_EN    : IN std_logic;  -- Immediate Register Latch Enable

			-- EX Control Signals
			MUXA_SEL           : IN std_logic;  -- MUX-A Sel
			MUXB_SEL           : IN std_logic;  -- MUX-B Sel
			ALU_OUTREG_EN      : IN std_logic;  	-- ALU output Register Enable
			EQ_COND            : IN std_logic;  -- Branch if (not) Equal to Zero
			-- ALU Operation Code
			ALU_OPCODE         : IN aluOpType; -- choose between implicit or exlicit coding, like std_logic_vector(ALU_OPC_SIZE -1 downto 0);
			
			-- MEM Control Signals
			DRAM_WE            : IN std_logic;  -- Data RAM Write Enable
			LMD_LATCH_EN       : IN std_logic;  -- LMD Register Latch Enable
			JUMP_EN            : IN std_logic;  -- JUMP Enable Signal for PC input MUX
			PC_LATCH_EN        : IN std_logic;  -- Program Counte Latch Enable

			-- WB Control signals
			WB_MUX_SEL         : IN std_logic;  -- Write Back MUX Sel
			RF_WE              : IN std_logic);
end DataPath_BASIC;

architecture STRUCTURE of DataPath_BASIC is

component REG_GENERIC is -- generic register
	generic(NBIT: integer:= numBit);
	port( 	CLK:	IN std_logic;
			RST:	IN std_logic;
			EN:	IN std_logic;
			DATA_IN: IN std_logic_vector(NBIT-1 downto 0);
			DATA_OUT:	OUT std_logic_vector(NBIT-1 downto 0));
end component;

component MUX21_GENERIC is -- generic multiplexer
	generic(NBIT: integer:= numBit);
	port( 	A: IN std_logic_vector(NBIT-1 downto 0);
			B:	IN std_logic_vector(NBIT-1 downto 0);
			SEL:	IN std_logic;
			Y:	OUT std_logic_vector(NBIT-1 downto 0));
end component;

component REGISTER_FILE is
	generic (NBIT: integer := numBit;
    		 NREG: integer := RFsize);
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
    generic (NBIT: integer := numBit;
    		 SIZE: integer := RAMsize);
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
  generic (N : integer := numBit);
  port   ( FUNC: IN aluOpType; -- Input for selecting the operation to be performed
           DATA1, DATA2: IN std_logic_vector(N-1 downto 0); -- Data inputs
           OUTALU: OUT std_logic_vector(N-1 downto 0)); -- Data outputs
end component;

component ADDER is -- specific adder to add 4 to the input
  generic (N : integer := numBit);
  port   ( CURR_ADDR: IN std_logic_vector(N-1 downto 0); -- input address
           NEXT_ADDR: OUT std_logic_vector(N-1 downto 0)); -- output address(i.e. input address + 4)
end component;

component EXTENDER is
  generic (	N : integer := numBit;
			IMM_field_lenght : integer := 16);
  port   ( NOT_EXT_IMM: IN std_logic_vector(IMM_field_lenght-1 downto 0); -- input data
           EXT_IMM: OUT std_logic_vector(N-1 downto 0)); -- output data(i.e. input data with sign extension)
end component;

component IRAM is
  generic (
    RAM_DEPTH : integer := IRAMsize;
    I_SIZE : integer := IR_SIZE);
  port (
    Rst  : in  std_logic;
    Addr : in  std_logic_vector(I_SIZE - 1 downto 0);
    Dout : out std_logic_vector(I_SIZE - 1 downto 0)
    );
end component;

signal current_PC : std_logic_vector(N-1 downto 0);
signal next_PC : std_logic_vector(N-1 downto 0);
signal current_NPC : std_logic_vector(N-1 downto 0);
signal next_NPC : std_logic_vector(N-1 downto 0);
signal next_IW : std_logic_vector(N-1 downto 0);
signal current_IW : std_logic_vector(N-1 downto 0);
signal WB1_I_OUT : std_logic_vector(N-1 downto 0);
signal WB1_R_OUT : std_logic_vector(N-1 downto 0);
signal A_IN : std_logic_vector(N-1 downto 0);
signal B_IN : std_logic_vector(N-1 downto 0);
signal IMM_IN : std_logic_vector(N-1 downto 0);
signal A_OUT : std_logic_vector(N-1 downto 0);
signal B_OUT : std_logic_vector(N-1 downto 0);
signal IMM_OUT : std_logic_vector(N-1 downto 0);
signal WB2_IN : std_logic_vector(N-1 downto 0);
signal WB2_OUT : std_logic_vector(N-1 downto 0);
signal WB_DATA : std_logic_vector(N-1 downto 0);
signal ALU_OP1 : std_logic_vector(N-1 downto 0);
signal ALU_OP2 : std_logic_vector(N-1 downto 0);
signal next_ALU_OUT : std_logic_vector(N-1 downto 0);
signal current_ALU_OUT : std_logic_vector(N-1 downto 0);
signal next_RAM_OUT : std_logic_vector(N-1 downto 0);
signal current_RAM_OUT : std_logic_vector(N-1 downto 0);

begin

-- registers:
PC_REG : REG_GENERIC
	generic map(32)
	port map(CLK => CLK, RST => RST, EN => PC_LATCH_EN, DATA_IN => next_PC, DATA_OUT => current_PC);

NPC_REG : REG_GENERIC
	generic map(32)
	port map(CLK => CLK, RST => RST, EN => NPC_LATCH_EN, DATA_IN => next_NPC, DATA_OUT => current_NPC);
	
IR_REG : REG_GENERIC
	generic map(32)
	port map(CLK => CLK, RST => RST, EN => IR_LATCH_EN, DATA_IN => next_IW, DATA_OUT => current_IW);
	
A_REG : REG_GENERIC
	generic map(32)
	port map(CLK => CLK, RST => RST, EN => RegA_LATCH_EN, DATA_IN => A_IN, DATA_OUT => A_OUT);

B_REG : REG_GENERIC
	generic map(32)
	port map(CLK => CLK, RST => RST, EN => RegB_LATCH_EN, DATA_IN => B_IN, DATA_OUT => B_OUT);

IMM_REG : REG_GENERIC
	generic map(32)
	port map(CLK => CLK, RST => RST, EN => RegIMM_LATCH_EN, DATA_IN => IMM_IN, DATA_OUT => IMM_OUT);

WB1_I_REG : REG_GENERIC
	generic map(32)
	port map(CLK => CLK, RST => RST, EN => WB_MUX_SEL, DATA_IN => current_IW(21-1 downto 16), DATA_OUT => WB1_I_OUT);

WB1_R_REG : REG_GENERIC
	generic map(32)
	port map(CLK => CLK, RST => RST, EN => WB_MUX_SEL, DATA_IN => current_IW(16-1 downto 11), DATA_OUT => WB1_R_OUT);

WB2_REG : REG_GENERIC
	generic map(32)
	port map(CLK => CLK, RST => RST, EN => WB_MUX_SEL, DATA_IN => WB2_IN, DATA_OUT => WB2_OUT);

ALU_OUT_REG : REG_GENERIC
	generic map(32)
	port map(CLK => CLK, RST => RST, EN => ALU_OUTREG_EN, DATA_IN => next_ALU_OUT, DATA_OUT => current_ALU_OUT);

LMD_REG : REG_GENERIC
	generic map(32)
	port map(CLK => CLK, RST => RST, EN => LMD_LATCH_EN, DATA_IN => next_RAM_OUT, DATA_OUT => current_RAM_OUT);
	
-- multiplexers:
PC_MUX : MUX21_GENERIC
	generic map(32)
	port map(A => current_ALU_OUT, B => current_NPC, SEL => JUMP_EN, Y => next_PC);

RD_MUX : MUX21_GENERIC
	generic map(32)
	port map(A => WB1_R_OUT, B => WB1_I_OUT, SEL => RegIMM_LATCH_EN, Y => WB2_IN);

OP1_MUX : MUX21_GENERIC
	generic map(32)
	port map(A => A_OUT, B => B_OUT, SEL => MUXA_SEL, Y => ALU_OP1);
	
OP2_MUX : MUX21_GENERIC
	generic map(32)
	port map(A => B_OUT, B => IMM_OUT, SEL => MUXB_SEL, Y => ALU_OP2);
	
OUT_MUX : MUX21_GENERIC
	generic map(32)
	port map(A => current_RAM_OUT, B => current_ALU_OUT, SEL => WB_MUX_SEL, Y => WB_DATA);

-- adder for next PC computation:
PC_ADDER : ADDER
	generic map (32)
	port map ( CURR_ADDR => current_PC, NEXT_ADDR => next_NPC);

-- register file:
-- current_IW(26-1 downto 21) -> addr1
-- current_IW(21-1 downto 16) -> addr2
-- current_IW(16-1 downto 11) -> addr3
RF : REGISTER_FILE
	generic map(32, RFsize) -- second num is number of regs
    port map(CLK => CLK, RST => RST, EN => '1', RD1 => '1', RD2 => '1', WR => RF_WE, ADD_WR => WB2_OUT, ADD_RD1 => current_IW(26-1 downto 21), ADD_RD2 => current_IW(21-1 downto 16), DATAIN => WB_DATA, OUT1 => A_IN, OUT2 => B_IN);
	
-- immediate sign extension
EXT : EXTENDER
	generic map(32, 16)
	port map(NOT_EXT_IMM => current_IW(16-1 downto 0), EXT_IMM => IMM_IN);

-- ALU:
ALU_i : ALU 
  generic map(32)
  port map(FUNC => ALU_OPCODE, DATA1 => ALU_OP1, DATA2 => ALU_OP2, OUTALU => next_ALU_OUT);
	
--data memory:
RAM : MEMORY
    generic map (32, RAMsize)
    port map(CLK => CLK, RST => RST, EN => '1', RD => '1', WR => DRAM_WE, ADDR => B_OUT, DATA_IN => current_ALU_OUT, DATA_OUT => next_RAM_OUT);

--instruction memory:
IRAM_i : IRAM
    generic map (RAM_DEPTH => IRAMsize, I_SIZE => 32)
    port map(Rst => RST, Addr => current_PC, Dout => next_IW);



end STRUCTURE;
