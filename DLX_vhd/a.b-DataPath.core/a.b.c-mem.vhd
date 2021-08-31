library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.Log2.all; -- for using the log2 algo, in order to compute the number of bits needed to address the cells

-- I suppose description of DRAM(data memory) can be the same as that of the RF. This code is the same written for the RF during lab3 but with one read port less.

entity MEMORY is
    generic (NBIT: integer := numBit;
    		 SIZE: integer := memSize);
    port (CLK: 		IN  std_logic;
	      RST: 		IN  std_logic;
	      EN: 		IN  std_logic;
	      RD: 		IN  std_logic;
	      WR: 		IN  std_logic;
	      ADDR: 	IN  std_logic_vector(Log2(SIZE)-1 downto 0);
	      DATA_IN: 	IN  std_logic_vector(NBIT-1 downto 0);
	      DATA_OUT: OUT std_logic_vector(NBIT-1 downto 0));
end MEMORY;

architecture BEHAVIOR of MEMORY is

	subtype MEM_ADDR is natural range 0 to SIZE-1; -- MEM_ADDR is a subset of natural with values from 0 to 31. This will be the number of memory cells NBIT wide of the data memory and it will be used as row number in the cells array
	type CELL_ARRAY is array(MEM_ADDR) of std_logic_vector(NBIT-1 downto 0); -- this is a type consisting in an array of as many elements of NBIT bits as many as the MEM_ADDR range
	signal DATAMEM : CELL_ARRAY; -- this is the signal that will represent the whole data memory

begin 

    process (CLK) --this process is activated only when the clock changes
    begin 
    
        if (rising_edge(CLK)) then --and only when the clock is rising we allow anything to happen

            if (RST = '1') then -- synch. RST is the highest priority event
            
                for i in 0 to SIZE - 1 loop
                    DATAMEM(i) <= (others=>'0');	-- all cells are set to 0
                end loop;
                
                DATA_OUT <= (others=>'0'); -- also outputs are set to 0, since the only possible output is zero
                
            elsif (EN = '1') then  -- this part of code is accessed only if RST is low(inactive) but EN is high(active)
            
                if (RD = '1') then
                    DATA_OUT <= DATAMEM(to_integer(unsigned(ADDR))); -- register addressed by ADDR (given as input to RF) is assigned to output 1
                end if; -- notice the cast to integer is needed since the address given as input is binary, while we address the DATAMEM in the RF through integers
				
				if (WR = '1') then
					DATAMEM(to_integer(unsigned(ADDR))) <= DATA_IN; -- data given as input in DATA_IN is assigned to register addressed by ADDR (given as input to RF)
				end if;
				
				-- since the read happens before the write, the output gets the value inside the mem that is then changed. this should be good for the pipeline
				
            end if;			
        end if;
    end process;
  
end BEHAVIOR;