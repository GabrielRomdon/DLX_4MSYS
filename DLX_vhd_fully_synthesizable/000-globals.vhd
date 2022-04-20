library ieee;
use ieee.std_logic_1164.all;
use work.Log2.all;

package myTypes is

    constant WORD		: integer :=  32;
    constant HALF_WORD		: integer :=  16;

    -- CONTROL UNIT --
    constant MICROCODE_MEM_SIZE : integer :=  45;
    constant OP_CODE_SIZE       : integer :=   6;	-- OPCODE field size
    constant FUNC_SIZE          : integer :=  11;	-- FUNC field size
    constant IR_SIZE            : integer :=  32;  	-- Instruction Word/Register size

    -- Control word sizes -> Hardwired
    constant CW_SIZE      : integer :=  18;		-- Control Word size
    constant NB_SIG_S1    : integer :=  2;	-- Control Word size
    constant NB_SIG_S2    : integer :=  4;	-- Control Word size
    constant NB_SIG_S3    : integer :=  5;	-- Control Word size
    constant NB_SIG_S4    : integer :=  4;	-- Control Word size
    constant CW1_SIZE     : integer :=  CW_SIZE;		-- Control Word size
    constant CW2_SIZE     : integer :=  CW1_SIZE - NB_SIG_S1;		-- Control Word size
    constant CW3_SIZE     : integer :=  CW2_SIZE - NB_SIG_S2;		-- Control Word size
    constant CW4_SIZE     : integer :=  CW3_SIZE - NB_SIG_S3;		-- Control Word size
    constant CW5_SIZE     : integer :=  CW4_SIZE - NB_SIG_S4;		-- Control Word size

    -- RAMs --
    constant IRAM_SIZE    : integer :=  64;  	-- IRAM size
    constant DRAM_SIZE    : integer :=  64;  	-- DRAM size

    -- RF --
    constant RF_SIZE            : integer :=  32;  	-- RF size
    constant MSB_ADD_RD1        : integer :=  25;  	-- Most significant bit for RD1 address in IR
    constant LSB_ADD_RD1        : integer :=  21;  	-- Least significant bit for RD1 address in IR
    constant MSB_ADD_RD2        : integer :=  20;  	-- Most significant bit for RD2 address in IR
    constant LSB_ADD_RD2        : integer :=  16;  	-- Least significant bit for RD2 address in IR
    constant MSB_ADD_RD3        : integer :=  15;  	-- Most significant bit for RD3 address in IR
    constant LSB_ADD_RD3        : integer :=  11;  	-- Least significant bit for RD3 address in IR
    constant REG31 		: std_logic_vector(Log2(RF_SIZE)-1 downto 0) := "11111";

    -- R-TYPE INSTRUCTION -- -> FUNC field
    constant RTYPE_ADD  : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000100000";    -- ADD RA,RB,RC
    constant RTYPE_SUB  : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000100010";    -- SUB RA,RB,RC
    constant RTYPE_AND  : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000100100";    -- AND RA,RB,RC
    constant RTYPE_OR   : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000100101";    -- OR  RA,RB,RC
    constant RTYPE_SLE  : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000101100";    -- SLE RA,RB,RC
    constant RTYPE_SGE  : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000101101";    -- SGE RA,RB,RC
    constant RTYPE_SLL  : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000000100";    -- SLL RA,RB,RC
    constant RTYPE_SRL  : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000000110";    -- SRL RA,RB,RC
    constant RTYPE_SNE  : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000101001";    -- SNE RA,RB,RC
    constant RTYPE_XOR  : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000100110";    -- XOR RA,RB,RC

    -- R-TYPE INSTRUCTION -- -> OPCODE field
    constant RTYPE : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "000000";          -- for ADD, SUB, AND, OR register-to-register operation

    -- I-TYPE INSTRUCTION -- -> OPCODE field
    constant ITYPE_ADDI   : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001000";    -- ADDI   RA,RB,INP1
    constant ITYPE_SUBI   : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001010";    -- SUBI   RA,RB,INP1
    constant ITYPE_ANDI   : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001100";    -- ANDI   RA,RB,INP1
    constant ITYPE_ORI    : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001101";    -- ORI    RA,RB,INP1
    constant ITYPE_XORI   : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001110";    -- XORI   RA,RB,INP1
    constant ITYPE_BEQZ   : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "000100";    -- BEQZ   RA,INP1
    constant ITYPE_BNEZ   : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "000101";    -- BNEZ   RA,INP1
    constant ITYPE_J      : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "000010";    -- J      INP1
    constant ITYPE_JAL    : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "000011";    -- JAL    INP1
    constant ITYPE_LW     : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "100011";    -- LW     RA,RB,INP1
    constant ITYPE_SW     : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "101011";    -- SW     RA,RB,INP1
    constant ITYPE_SLEI   : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "011100";    -- SLEI   RA,RB,INP1
    constant ITYPE_SGEI   : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "011101";    -- SGEI   RA,RB,INP1
    constant ITYPE_SLLI   : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "010100";    -- SLLI   RA,RB,INP1
    constant ITYPE_SNEI   : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "011001";    -- SNEI   RA,RB,INP1
    constant ITYPE_SRLI   : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "010110";    -- SRLI   RA,RB,INP1
    constant ITYPE_NOP    : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "010101";    -- NOP

    type aluOpType is (
        NOP, 
        ADDS, 
        SUBS, 
        ANDS, 
        ORS, 
        XORS,
        SLE,
        SGE,
        SNE,
        SRLS,
        SLLS
    );

end myTypes;

