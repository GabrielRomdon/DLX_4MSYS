library IEEE;
use IEEE.std_logic_1164.all;
use work.Log2.all;
use work.myTypes.all;

entity DP_CU is
	generic(N : integer := numBit;
			IR_SIZE : integer := 32);
	port(	CLK_DP: IN std_logic;
			CLK_CU: IN std_logic;
			RST: IN std_logic);
end DP_CU;

architecture STRUCTURE of DP_CU is

component DataPath_BASIC is
	generic(N : integer := numBit;
			IR_SIZE : integer := 32);
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
			RF_WE              : IN std_logic;
			
			IR_OUT			   : OUT std_logic_vector(IR_SIZE-1 downto 0));
end component;

component dlx_cu is
  generic (
    MICROCODE_MEM_SIZE :     integer := 45;  -- Microcode Memory Size
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

-- intermediate signals
signal IR_LATCH_EN        : std_logic;
signal NPC_LATCH_EN       : std_logic;
signal RegA_LATCH_EN      : std_logic;
signal RegB_LATCH_EN      : std_logic;
signal RegIMM_LATCH_EN    : std_logic;
signal MUXA_SEL           : std_logic;
signal MUXB_SEL           : std_logic;
signal ALU_OUTREG_EN      : std_logic;
signal EQ_COND            : std_logic;
signal ALU_OPCODE         : aluOpType;
signal DRAM_WE            : std_logic;
signal LMD_LATCH_EN       : std_logic;
signal JUMP_EN            : std_logic;
signal PC_LATCH_EN        : std_logic;
signal WB_MUX_SEL         : std_logic;
signal RF_WE              : std_logic;
signal IR_intermediate	  : std_logic_vector(IR_SIZE-1 downto 0);

begin

-- datapath:
DP : DataPath_BASIC
	generic map(N)
	port map(CLK => CLK_DP, RST => RST, IR_LATCH_EN => IR_LATCH_EN, NPC_LATCH_EN => NPC_LATCH_EN, RegA_LATCH_EN => RegA_LATCH_EN, RegB_LATCH_EN => RegB_LATCH_EN, RegIMM_LATCH_EN => RegIMM_LATCH_EN, MUXA_SEL => MUXA_SEL, MUXB_SEL => MUXB_SEL, ALU_OUTREG_EN => ALU_OUTREG_EN, EQ_COND => EQ_COND, ALU_OPCODE => ALU_OPCODE, DRAM_WE => DRAM_WE, LMD_LATCH_EN => LMD_LATCH_EN, JUMP_EN => JUMP_EN, PC_LATCH_EN => PC_LATCH_EN, WB_MUX_SEL => WB_MUX_SEL, RF_WE => RF_WE, IR_OUT => IR_intermediate);

-- control unit:
CU : dlx_cu
	generic map(45, 11, 6, 32, 15)
	port map(Clk => CLK_CU, Rst => RST, IR_IN => IR_intermediate, IR_LATCH_EN => IR_LATCH_EN, NPC_LATCH_EN => NPC_LATCH_EN, RegA_LATCH_EN => RegA_LATCH_EN, RegB_LATCH_EN => RegB_LATCH_EN, RegIMM_LATCH_EN => RegIMM_LATCH_EN, MUXA_SEL => MUXA_SEL, MUXB_SEL => MUXB_SEL, ALU_OUTREG_EN => ALU_OUTREG_EN, EQ_COND => EQ_COND, ALU_OPCODE => ALU_OPCODE, DRAM_WE => DRAM_WE, LMD_LATCH_EN => LMD_LATCH_EN, JUMP_EN => JUMP_EN, PC_LATCH_EN => PC_LATCH_EN, WB_MUX_SEL => WB_MUX_SEL, RF_WE => RF_WE);

end STRUCTURE;
