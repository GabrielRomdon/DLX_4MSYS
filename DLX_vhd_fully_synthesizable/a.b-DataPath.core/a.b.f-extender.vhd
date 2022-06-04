-- ALU
-- ----------------------------------------------------------
-- Editor(s)    : Coralie Allioux, Gabriel Romero, Simone Valente
-- Last updated : 09/Aug/2021
-- Features     : For the extension of the sign of the immediate input. Uses the numeric_std library's instruction "resize"

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use work.myTypes.all;

entity EXTENDER is
  generic (NBIT : integer := WORD;
	   IMM_MIN: integer := HALF_WORD;
	   IMM_MAX : integer := MAX_IMM_SIZE);
  port   ( NOT_EXT_IMM:     IN std_logic_vector(IMM_MAX-1 downto 0); -- input data
           SIGNED_IMM:      IN std_logic;
           IS_JUMP:         IN std_logic;
           EXT_IMM:         OUT std_logic_vector(NBIT-1 downto 0)); -- output data(i.e. input data with sign extension)
end EXTENDER;

architecture BEHAVIOR of EXTENDER is

begin

-- process that extends the sign of every input data
EXTENSION: process (IS_JUMP, SIGNED_IMM, NOT_EXT_IMM)
  begin
  if IS_JUMP='1' then
	  if SIGNED_IMM='1' then
		  EXT_IMM <= std_logic_vector(resize(signed(NOT_EXT_IMM), NBIT));
	  else
		  EXT_IMM <= std_logic_vector(resize(unsigned(NOT_EXT_IMM), NBIT));
	  end if;
  else
	  if SIGNED_IMM='1' then
		  EXT_IMM <= std_logic_vector(resize(signed(NOT_EXT_IMM(IMM_MIN-1 downto 0)), NBIT));
	  else
		  EXT_IMM <= std_logic_vector(resize(unsigned(NOT_EXT_IMM(IMM_MIN-1 downto 0)), NBIT));
	  end if;
  end if;
  end process EXTENSION;

end BEHAVIOR;

