library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
--use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all; --included for using the unsigned type
use work.myTypes.all;

entity ALU is
  generic (NBIT : integer := numBit);
  port 	  (FUNC: IN TYPE_OP;
           DATA1, DATA2: IN unsigned(NBIT-1 downto 0);
           OUTALU: OUT unsigned(NBIT-1 downto 0));
end ALU;

architecture BEHAVIOR of ALU is

begin

P_ALU: process (FUNC, DATA1, DATA2)
  -- complete all the requested functions
variable D2: integer;
variable temp_DATA: integer;

  begin
    case FUNC is
	when ADD 		=> OUTALU <= DATA1 + DATA2;
	when SUB 		=> OUTALU <= DATA1 - DATA2;
	when MULT 		=> OUTALU <= DATA1(NBIT/2-1  downto 0) * DATA2(NBIT/2-1 downto 0);
	when DIV 		=> OUTALU <= DATA1 / DATA2;
	 -- bitwise operations:
	when BITAND 	=> OUTALU <= DATA1 AND DATA2;
	when BITOR 		=> OUTALU <= DATA1 OR DATA2;
	when BITXOR 	=> OUTALU <= DATA1 XOR DATA2;
	-- shift operations:
	when FUNCLSL 	=> OUTALU <= DATA1(NBIT-2 downto 0) & '0'; -- logical shift left
	when FUNCLSR 	=> OUTALU <= '0' & DATA1(NBIT-1 downto 1); -- logical shift right
	-- rotation operations:
	when FUNCRL 	=> OUTALU <= DATA1(NBIT-2 downto 0) & DATA1(NBIT-1); -- rotate left
	when FUNCRR 	=> OUTALU <= DATA1(0) & DATA1(NBIT-1 downto 1); -- rotate right
	-- barrel rotation operations:
	when FUNCRL_B 	=>  -- rotate left
						temp_DATA := to_integer(DATA2);
						while(temp_DATA > NBIT) loop
							temp_DATA := temp_DATA - NBIT;
						end loop;
						D2 := NBIT - temp_DATA;
						OUTALU <= DATA1(D2-1 downto 0) & DATA1(NBIT-1 downto D2);
	when FUNCRR_B 	=>  -- rotate right
						temp_DATA := to_integer(DATA2);
						while(temp_DATA > NBIT) loop
							temp_DATA := temp_DATA - NBIT;
						end loop;
						D2 := temp_DATA;
						OUTALU <= DATA1(D2-1 downto 0) & DATA1(NBIT-1 downto D2);
	when others => null;
    end case; 
  end process P_ALU;

end BEHAVIOR;
