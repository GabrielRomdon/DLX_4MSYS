-- ALU
-- ----------------------------------------------------------
-- Editor(s)    : Coralie Allioux, Gabriel Romero, Simone Valente
-- Last updated : 11/May/2021
-- Features     : R-Type and I-Type instructions

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use WORK.myTypes.all;

entity ALU is
  generic (N : integer := 32);
  port   ( FUNC: IN aluOpType; -- Input for selecting the operation to be performed
           DATA1, DATA2: IN std_logic_vector(N-1 downto 0); -- Data inputs
           OUTALU: OUT std_logic_vector(N-1 downto 0)); -- Data outputs
end ALU;

architecture BEHAVIOR of ALU is

begin

-- process for switching among the different functions of the ALU
P_ALU: process (FUNC, DATA1, DATA2)
  begin
    case FUNC is
    when ADDS       => OUTALU <= DATA1 + DATA2; -- addition
    when SUBS       => OUTALU <= DATA1 - DATA2; -- subtraction
    when ANDS       => OUTALU <= DATA1 AND DATA2; -- bitwise AND operation
    when ORS        => OUTALU <= DATA1 OR DATA2; -- bitwise OR operation
    when XORS       => OUTALU <= DATA1 XOR DATA2; -- bitwise XOR operation
    when SLE        => OUTALU <= DATA1 <= DATA2; -- less or equal
    when SGE        => OUTALU <= DATA1 >= DATA2; -- greater or equal
    when SNE        => OUTALU <= DATA1 /= DATA2; -- not equal
    when SRLS       => OUTALU <= std_logic_vector(shift_right(unsigned(DATA1), to_integer(unsigned(DATA2)))); -- logical shift right 
    when SLLS       => OUTALU <= std_logic_vector(shift_left(unsigned(DATA1), to_integer(unsigned(DATA2))));  -- logical shift left
    when NOP        => null;
    when others     => null;
    end case;
  end process P_ALU;

end BEHAVIOR;

