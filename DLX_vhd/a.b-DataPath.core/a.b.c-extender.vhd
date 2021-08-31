-- ALU
-- ----------------------------------------------------------
-- Editor(s)    : Coralie Allioux, Gabriel Romero, Simone Valente
-- Last updated : 09/Aug/2021
-- Features     : For the extension of the sign of the immediate input. Uses the numeric_std library's instruction "resize"

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use WORK.myTypes.all;

entity EXTENDER is
  generic (	N : integer := 32;
			IMM_field_lenght : integer := 16);
  port   ( NOT_EXT_IMM: IN std_logic_vector(IMM_field_lenght-1 downto 0); -- input data
           EXT_IMM: OUT std_logic_vector(N-1 downto 0)); -- output data(i.e. input data with sign extension)
end EXTENDER;

architecture BEHAVIOR of EXTENDER is

begin

-- process that extends the sign of every input data
EXTENSION: process (NOT_EXT_IMM)
  begin
	EXT_IMM <= std_logic_vector(resize(signed(NOT_EXT_IMM), N'length));;
  end process EXTENSION;

end BEHAVIOR;

