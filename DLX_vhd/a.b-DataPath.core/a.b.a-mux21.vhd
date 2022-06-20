-- Single bit 2 to 1 mux
-- ----------------------------------------------------------
-- Editor(s)    : Coralie Allioux, Gabriel Romero, Simone Valente
-- Last updated : 04/Jun/2022
-- Features     : behavioural 2 to 1 multiplexer

library IEEE;
use IEEE.std_logic_1164.all;
use work.myTypes.all;

entity MUX21 is
	port( 	A: IN std_logic;      -- 0 input
			B:	IN std_logic;     -- 1 input
			SEL:	IN std_logic; -- selection signal
			Y:	OUT std_logic);   -- output
end MUX21;

architecture BEHAVIOR of MUX21 is
begin
process (SEL,A,B)
	begin
	if SEL = '0' then
		Y <= A;
	elsif SEL = '1' then
		Y <= B;
	end if;
end process;
end BEHAVIOR;


library IEEE;
use IEEE.std_logic_1164.all;
use work.myTypes.all;
-- Multiple bit 2 to 1 mux
entity MUX21_GENERIC is
	generic(NBIT: integer:= WORD);
	port( 	A: IN std_logic_vector(NBIT-1 downto 0);
			B:	IN std_logic_vector(NBIT-1 downto 0);
			SEL:	IN std_logic;
			Y:	OUT std_logic_vector(NBIT-1 downto 0));
end MUX21_GENERIC;

architecture BEHAVIOR of MUX21_GENERIC is
begin

process (SEL,A,B)
	begin
	if SEL = '0' then
		Y <= A;
	elsif SEL = '1' then
		Y <= B;
	end if;
end process;

end BEHAVIOR;
