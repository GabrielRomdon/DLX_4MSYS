-- ALU
-- ----------------------------------------------------------
-- Editor(s)    : Coralie Allioux, Gabriel Romero, Simone Valente
-- Last updated : 29/Jul/2021
-- Features     : Basic version. Using shift_left and shift_right functions from numeric_std

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
    when SLE        => if (DATA1 <= DATA2) then OUTALU <= std_logic_vector(to_unsigned(1, N)); else OUTALU <= std_logic_vector(to_unsigned(0, N)); end if; -- less or equal
    when SGE        => if (DATA1 >= DATA2) then OUTALU <= std_logic_vector(to_unsigned(1, N)); else OUTALU <= std_logic_vector(to_unsigned(0, N)); end if; -- greater or equal
    when SNE        => if (DATA1 /= DATA2) then OUTALU <= std_logic_vector(to_unsigned(1, N)); else OUTALU <= std_logic_vector(to_unsigned(0, N)); end if; -- not equal
    when SRLS       => OUTALU <= std_logic_vector(shift_right(unsigned(DATA1), to_integer(unsigned(DATA2)))); -- logical shift right 
    when SLLS       => OUTALU <= std_logic_vector(shift_left(unsigned(DATA1), to_integer(unsigned(DATA2))));  -- logical shift left
    when NOP        => OUTALU <= (others => '0');
    when others     => OUTALU <= (others => '0');
    end case;
  end process P_ALU;

end BEHAVIOR;

