library IEEE;
use IEEE.std_logic_1164.all;
use work.myTypes.all;

entity MUX21_SINGLEBIT is
	port( 	A: 	 IN std_logic;
			B:	 IN std_logic;
			SEL: IN std_logic;
			Y:	 OUT std_logic);
end MUX21_SINGLEBIT;

architecture BEHAVIOR of MUX21_SINGLEBIT is
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
