-- ALU
-- ----------------------------------------------------------
-- Editor(s)    : Coralie Allioux, Gabriel Romero, Simone Valente
-- Last updated : 04/Jun/2022
-- Features     : deeply described version. Barrel shifter and logic gates described explicitly.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use WORK.myTypes.all;

entity ALU is
  generic (N : integer := WORD);
  port   ( FUNC: IN aluOpType; -- Input for selecting the operation to be performed
           DATA1, DATA2: IN std_logic_vector(N-1 downto 0); -- Data inputs
           OUTALU: OUT std_logic_vector(N-1 downto 0)); -- Data outputs
end ALU;

architecture BEHAVIOR of ALU is

  -- Component declaration
  component NAND3
    port    ( A: IN std_logic; -- Input A
              B: IN std_logic; -- Input B
              C: IN std_logic; -- Input C
              Y: OUT std_logic); -- Output
  end component;

  component NAND4
    port    ( A: IN std_logic; -- Input A
              B: IN std_logic; -- Input B
              C: IN std_logic; -- Input C
              D: IN std_logic; -- Input D
              Y: OUT std_logic); -- Output
  end component;

  component BARREL_SHIFTER
    generic ( N : integer := 32);
    port   ( CONF:         IN std_logic; -- Input for selecting either left (CONF=0) or right (CONF=1)
             DATA1, DATA2: IN std_logic_vector(N-1 downto 0); -- Data inputs
             OUTPUT:       OUT std_logic_vector(N-1 downto 0)); -- Data outputs
  end component;

  -- Signal declaration
  ---- Signals for the logic gates
  signal S  : std_logic_vector(3 downto 0);
  signal L0 : std_logic_vector(N-1 downto 0);
  signal L1 : std_logic_vector(N-1 downto 0);
  signal L2 : std_logic_vector(N-1 downto 0);
  signal L3 : std_logic_vector(N-1 downto 0);
  signal DATA1_b : std_logic_vector(N-1 downto 0);
  signal DATA2_b : std_logic_vector(N-1 downto 0);
  signal Y_LOGIC : std_logic_vector(N-1 downto 0);
  ---- Signals for the shifter
  signal R_SHIFTER_IN : std_logic;
  signal OUT_SHIFTER : std_logic_vector(N-1 downto 0);

begin

-- process for switching among the different functions of the ALU
P_ALU: process (FUNC, DATA1, DATA2, Y_LOGIC, OUT_SHIFTER)
  begin
    case FUNC is
      when ADDS       => OUTALU <= DATA1 + DATA2; -- addition
      when SUBS       => OUTALU <= DATA1 - DATA2; -- subtraction
      when ANDS       => OUTALU <= Y_LOGIC; -- bitwise AND operation
      when ORS        => OUTALU <= Y_LOGIC; -- bitwise OR operation
      when XORS       => OUTALU <= Y_LOGIC; -- bitwise XOR operation
      when SLE        => if (signed(DATA1) <= signed(DATA2)) then OUTALU <= std_logic_vector(to_unsigned(1, N)); else OUTALU <= std_logic_vector(to_unsigned(0, N)); end if; -- less or equal
      when SGE        => if (signed(DATA1) >= signed(DATA2)) then OUTALU <= std_logic_vector(to_unsigned(1, N)); else OUTALU <= std_logic_vector(to_unsigned(0, N)); end if; -- greater or equal
      when SNE        => if (signed(DATA1) /= signed(DATA2)) then OUTALU <= std_logic_vector(to_unsigned(1, N)); else OUTALU <= std_logic_vector(to_unsigned(0, N)); end if; -- not equal
      when SRLS       => OUTALU <= OUT_SHIFTER; -- logical shift right 
      when SLLS       => OUTALU <= OUT_SHIFTER;  -- logical shift left
      when NOP        => OUTALU <= (others => '0');
      when others     => OUTALU <= (others => '0');
    end case;
  end process P_ALU;

-------------------------------------------
-- Logic for the gates (ANDS, ORS, XORS) --
-------------------------------------------
-- Auxiliary signals
DATA1_b <= NOT ( DATA1 );    
DATA2_b <= NOT ( DATA2 );    

-- Set of NAND gates for the Logic implementation
S0_NAND: for I in 1 to N generate
  NAND31I: NAND3
    Port Map (DATA1_b(I-1), DATA2_b(I-1), S(0), L0(I-1));
end generate;

S1_NAND: for I in 1 to N generate
  NAND31I: NAND3
    Port Map (DATA1_b(I-1), DATA2(I-1), S(1), L1(I-1));
end generate;

S2_NAND: for I in 1 to N generate
  NAND31I: NAND3
    Port Map (DATA1(I-1), DATA2_b(I-1), S(2), L2(I-1));
end generate;

S3_NAND: for I in 1 to N generate
  NAND31I: NAND3
    Port Map (DATA1(I-1), DATA2(I-1), S(3), L3(I-1));
end generate;

YLOGIC_NAND: for I in 1 to N generate
  NAND41I: NAND4
    Port Map (L0(I-1), L1(I-1), L2(I-1), L3(I-1), Y_LOGIC(I-1));
end generate;

-- Decoder for choosing 'S' according to the logic input
P_LOGIC: process (FUNC)
  begin
    case FUNC is
      when ANDS    => S <= "1000";
      when ORS     => S <= "1110";
      when XORS    => S <= "0110";
      when others  => S <= "0000";
    end case;
end process P_LOGIC;
--------------------------------------------------
-- End of Logic for the gates (ANDS, ORS, XORS) --
--------------------------------------------------

--------------------------------------------------
-- Shifter --
--------------------------------------------------
R_SHIFTER_IN <= '1' when (FUNC = SRLS) else '0'; 

SHIFTER: BARREL_SHIFTER
  Generic Map ( N => N )
  Port Map (R_SHIFTER_IN, DATA1, DATA2, OUT_SHIFTER);

--------------------------------------------------
-- End of shifter --
--------------------------------------------------

end BEHAVIOR;
