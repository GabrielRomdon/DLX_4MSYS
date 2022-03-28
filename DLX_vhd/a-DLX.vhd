library IEEE;
use IEEE.std_logic_1164.all;
use work.Log2.all;
use work.myTypes.all;

entity DLX is
	generic(PC_SIZE : integer := numBit;
			IR_SIZE : integer := 32);
	port(	CLK: IN std_logic;
			RST: IN std_logic);
end DLX;

architecture DLX_RTL of DLX is

component REG_GENERIC is -- generic register
	generic(NBIT: integer:= numBit);
	port( 	CLK:	IN std_logic;
			RST:	IN std_logic;
			EN:	IN std_logic;
			DATA_IN: IN std_logic_vector(NBIT-1 downto 0);
			DATA_OUT:	OUT std_logic_vector(NBIT-1 downto 0));
end component;

component IRAM is
  generic (
    RAM_DEPTH : integer := IRAMsize;
    I_SIZE : integer := IR_SIZE);
  port (
    RST  : in  std_logic;
    ADDR : in  std_logic_vector(I_SIZE - 1 downto 0);
    DOUT : out std_logic_vector(I_SIZE - 1 downto 0)
    );
end component;

component DataPath_BASIC is
	generic(N : integer := numBit;
			IR_SIZE : integer := 32);
	port(	CLK: IN std_logic;
			RST: IN std_logic;

      IR_IN: IN std_logic_vector(IR_SIZE-1 downto 0);
			
			-- IF Control Signal
			IR_LATCH_EN        : IN std_logic;  -- Instruction Register Latch Enable
			NPC_LATCH_EN       : IN std_logic;  -- NextProgramCounter Register Latch Enable
			
			-- ID Control Signals
			RegA_LATCH_EN      : IN std_logic;  -- Register A Latch Enable
			RegB_LATCH_EN      : IN std_logic;  -- Register B Latch Enable
			RegIMM_LATCH_EN    : IN std_logic;  -- Immediate Register Latch Enable
		  SIGNED_IMM         : IN std_logic;  -- Extender sel, signed or unsigned immediate

			-- EX Control Signals
			MUXA_SEL           : IN std_logic;  -- MUX-A Sel
			MUXB_SEL           : IN std_logic;  -- MUX-B Sel
			ALU_OUTREG_EN      : IN std_logic;  	-- ALU output Register Enable
			EQ_COND            : IN std_logic;  -- Branch if (not) Equal to Zero
			IS_JUMP            : IN std_logic;  -- Is jump or branch instruction
			-- ALU Operation Code
			ALU_OPCODE         : IN aluOpType; -- choose between implicit or exlicit coding, like std_logic_vector(ALU_OPC_SIZE -1 downto 0);
			
			-- MEM Control Signals
			DRAM_WE            : IN std_logic;  -- Data RAM Write Enable
			LMD_LATCH_EN       : IN std_logic;  -- LMD Register Latch Enable
			JUMP_EN            : IN std_logic;  -- JUMP Enable Signal for PC input MUX
			PC_LATCH_EN        : IN std_logic;  -- Program Counte Latch Enable

			-- WB Control signals
			WB_MUX_SEL         : IN std_logic;  -- Write Back MUX Sel
			RF_WE              : IN std_logic;
			
			PC_IN			   : IN std_logic_vector(N-1 downto 0);
			PC_BUS			   : OUT std_logic_vector(N-1 downto 0));
end component;

component dlx_cu is
  generic (
    MICROCODE_MEM_SIZE :     integer := 45;  -- Microcode Memory Size
    FUNC_SIZE          :     integer := 11;  -- Func Field Size for R-Type Ops
    OP_CODE_SIZE       :     integer := 6;  -- Op Code Size
    -- ALU_OPC_SIZE       :     integer := 6;  -- ALU Op Code Word Size
    IR_SIZE            :     integer := 32;  -- Instruction Register Size    
    CW_SIZE            :     integer := 16);  -- Control Word Size
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
		SIGNED_IMM         : out std_logic;  -- Extender sel, signed or unsigned immediate

    -- EX Control Signals
    MUXA_SEL           : out std_logic;  -- MUX-A Sel
    MUXB_SEL           : out std_logic;  -- MUX-B Sel
    ALU_OUTREG_EN      : out std_logic;  -- ALU Output Register Enable
    EQ_COND            : out std_logic;  -- Branch if (not) Equal to Zero
    IS_JUMP            : out std_logic;  -- Is jump or branch instruction
    -- ALU Operation Code
    ALU_OPCODE         : out aluOpType; -- choose between implicit or exlicit coding, like std_logic_vector(ALU_OPC_SIZE -1 downto 0);
    
    -- MEM Control Signals
    DRAM_WE            : out std_logic;  -- Data RAM Write Enable
    LMD_LATCH_EN       : out std_logic;  -- LMD Register Latch Enable
    JUMP_EN            : out std_logic;  -- JUMP Enable Signal for PC input MUX
    PC_LATCH_EN        : out std_logic;  -- Program Counte Latch Enable

    -- WB Control signals
    WB_MUX_SEL         : out std_logic;  -- Write Back MUX Sel
    RF_WE              : out std_logic);  -- Register File Write Enable

end component;

signal PC_BUS: std_logic_vector(PC_SIZE-1 downto 0);
signal current_PC : std_logic_vector(PC_SIZE-1 downto 0);
signal next_IW : std_logic_vector(IR_SIZE-1 downto 0);
signal current_IW : std_logic_vector(IR_SIZE-1 downto 0);

-- intermediate signals
signal IR_LATCH_EN        : std_logic;
signal NPC_LATCH_EN       : std_logic;
signal RegA_LATCH_EN      : std_logic;
signal RegB_LATCH_EN      : std_logic;
signal RegIMM_LATCH_EN    : std_logic;
signal SIGNED_IMM         : std_logic;
signal MUXA_SEL           : std_logic;
signal MUXB_SEL           : std_logic;
signal ALU_OUTREG_EN      : std_logic;
signal EQ_COND            : std_logic;
signal IS_JUMP            : std_logic;
signal ALU_OPCODE         : aluOpType;
signal DRAM_WE            : std_logic;
signal LMD_LATCH_EN       : std_logic;
signal JUMP_EN            : std_logic;
signal PC_LATCH_EN        : std_logic;
signal WB_MUX_SEL         : std_logic;
signal RF_WE              : std_logic;

begin

-- registers:
PC_REG : REG_GENERIC
	generic map(32)
	port map(CLK => CLK, RST => RST, EN => PC_LATCH_EN, DATA_IN => PC_BUS, DATA_OUT => current_PC);

--instruction register
-- VALUE RESET => address 80000000, not 0 which would be an ADD
current_IW <= next_IW;

--instruction memory:
IRAM_i : IRAM
    generic map (RAM_DEPTH => IRAMsize, I_SIZE => 32)
    port map(Rst => RST, Addr => current_PC, Dout => next_IW);

-- datapath:
DP : DataPath_BASIC
	generic map(PC_SIZE)
	port map(CLK => CLK, RST => RST, IR_IN => current_IW, IR_LATCH_EN => IR_LATCH_EN, NPC_LATCH_EN => NPC_LATCH_EN, RegA_LATCH_EN => RegA_LATCH_EN, RegB_LATCH_EN => RegB_LATCH_EN, RegIMM_LATCH_EN => RegIMM_LATCH_EN, SIGNED_IMM => SIGNED_IMM, MUXA_SEL => MUXA_SEL, MUXB_SEL => MUXB_SEL, ALU_OUTREG_EN => ALU_OUTREG_EN, EQ_COND => EQ_COND, IS_JUMP => IS_JUMP, ALU_OPCODE => ALU_OPCODE, DRAM_WE => DRAM_WE, LMD_LATCH_EN => LMD_LATCH_EN, JUMP_EN => JUMP_EN, PC_LATCH_EN => PC_LATCH_EN, WB_MUX_SEL => WB_MUX_SEL, RF_WE => RF_WE, PC_IN => current_PC, PC_BUS => PC_BUS);

-- control unit:
CU : dlx_cu
	generic map(45, 11, 6, 32, 16)
	port map(Clk => CLK, Rst => RST, IR_IN => current_IW, IR_LATCH_EN => IR_LATCH_EN, NPC_LATCH_EN => NPC_LATCH_EN, RegA_LATCH_EN => RegA_LATCH_EN, RegB_LATCH_EN => RegB_LATCH_EN, RegIMM_LATCH_EN => RegIMM_LATCH_EN, SIGNED_IMM => SIGNED_IMM, MUXA_SEL => MUXA_SEL, MUXB_SEL => MUXB_SEL, ALU_OUTREG_EN => ALU_OUTREG_EN, EQ_COND => EQ_COND, IS_JUMP => IS_JUMP, ALU_OPCODE => ALU_OPCODE, DRAM_WE => DRAM_WE, LMD_LATCH_EN => LMD_LATCH_EN, JUMP_EN => JUMP_EN, PC_LATCH_EN => PC_LATCH_EN, WB_MUX_SEL => WB_MUX_SEL, RF_WE => RF_WE);

end DLX_RTL;
