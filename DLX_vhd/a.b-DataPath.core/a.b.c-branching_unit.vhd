-- ALU
-- ----------------------------------------------------------
-- Editor(s)    : Coralie Allioux, Gabriel Romero, Simone Valente
-- Last updated : 14/Nov/2021
-- Features     : analyses the kind of branch and determines if the branch has to be taken or not.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use work.myTypes.all;

entity BRANCHING_UNIT is
  generic (	N : integer := 32);
  port   (	Reg_A: IN std_logic_vector(N-1 downto 0); -- from pipeline register A
			EQ_cond: IN std_logic; -- 1 if BEQZ, 0 if BNEZ
			branch_taken: OUT std_logic); -- 1 if branch is taken. 0 otherwise
end BRANCHING_UNIT;

architecture BEHAVIOR of BRANCHING_UNIT is

begin

-- process that extends the sign of every input data
process (Reg_A, EQ_cond)
	begin
		if (EQ_cond = '1') then
			if (Reg_A = "00000000000000000000000000000000") then
				branch_taken <= '1'; -- beqz and equal-to-zero condition satisfied
			else
				branch_taken <= '0'; -- beqz and equal-to-zero condition NOT satisfied
			end if;
		else if (EQ_cond = '1') then
			if (Reg_A = "00000000000000000000000000000000") then
				branch_taken <= '0'; -- bNez and not-equal-to-zero condition satisfied
			else
				branch_taken <= '1'; -- bNez and not-equal-to-zero condition NOT satisfied
			end if;
		else
			branch_taken <= '0'; -- default
		end if;
	end process;

end BEHAVIOR;

