-- LOGARITHM FUNCTION
-- ----------------------------------------------------------
-- Editor(s)    : Coralie Allioux, Gabriel Romero, Simone Valente
-- Last updated : 04/Jun/2022
-- Features     : Function to compute the logarithm base 2 of the argument.
--                Called at compile time to compute the length of the addresses

library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

package Log2 is

		function Log2 (x:integer) return integer ;

end Log2;

package body Log2 is

		function Log2 (x:integer) return integer is
				variable temp : integer := x ;
				variable n : integer := 0 ;
			begin
				while temp > 1 loop
					temp := temp /2;
					n := n + 1;
				end loop;

				if x > 2**n then
					return (n + 1);
				else
					return (n);
				end if;
		end function;

end Log2;
