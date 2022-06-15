library IEEE;
use IEEE.std_logic_1164.all;
use work.Log2.all;
use work.myTypes.all;

entity tb_dlx is
end tb_dlx;

architecture TEST of tb_dlx is
    signal Clock: std_logic := '0';
    signal Reset: std_logic := '1';
    signal i_addr: std_logic_vector(IR_SIZE-1 downto 0);
    signal i_data: std_logic_vector(IR_SIZE-1 downto 0);
    signal d_rr: std_logic;
    signal d_wr: std_logic;
    signal d_addr: std_logic_vector(Log2(DRAM_SIZE)-1 downto 0);
    signal d_data_in: std_logic_vector(WORD-1 downto 0);
    signal d_data_out: std_logic_vector(WORD-1 downto 0);
    
    component IRAM
        generic (
          RAM_DEPTH : integer := IRAM_SIZE;
          I_SIZE : integer := IR_SIZE);
        port (
          Rst  : in  std_logic;
          Addr : in  std_logic_vector(I_SIZE - 1 downto 0);
          Dout : out std_logic_vector(I_SIZE - 1 downto 0)
          );
    end component;

    component MEMORY
    generic (NBIT: integer := WORD;
    		 SIZE: integer := DRAM_SIZE);
    port (CLK: 		IN  std_logic;
	      RST: 		IN  std_logic;  -- Low
	      EN: 		IN  std_logic;
	      RD: 		IN  std_logic;
	      WR: 		IN  std_logic;
	      ADDR: 	IN  std_logic_vector(Log2(SIZE)-1 downto 0);
	      DATA_IN: 	IN  std_logic_vector(NBIT-1 downto 0);
	      DATA_OUT: OUT std_logic_vector(NBIT-1 downto 0));
    end component;

    component DLX
	port(	CLK: IN std_logic;
		RST: IN std_logic;

		-- IRAM SIGNALS
		I_ADDR: OUT std_logic_vector(IR_SIZE-1 downto 0);
		I_DATA: IN std_logic_vector(IR_SIZE-1 downto 0);

		-- DRAM SIGNALS
		D_RR: OUT std_logic;
		D_WR: OUT std_logic;
		D_ADDR: OUT std_logic_vector(Log2(DRAM_SIZE)-1 downto 0);
		D_DATA_IN: OUT std_logic_vector(WORD-1 downto 0);
		D_DATA_OUT: IN std_logic_vector(WORD-1 downto 0));
    end component;
begin

	IMEM: IRAM
	Port Map (Reset, i_addr, i_data);

	DMEM: MEMORY
	Port Map (Clock, Reset, '1', d_rr, d_wr, d_addr, d_data_in, d_data_out);

        -- instance of DLX
	U1: DLX
	Port Map (Clock, Reset, i_addr, i_data, d_rr, d_wr, d_addr, d_data_in, d_data_out);
	

        PCLOCK : process(Clock)
	begin
		Clock <= not(Clock) after 0.5 ns;	
	end process;
	
	--Reset <= '0', '1' after 6 ns, '0' after 11 ns, '1' after 15 ns;
	Reset <= '0', '1' after 6 ns;
       

end TEST;

-------------------------------

configuration CFG_TB of tb_dlx  is
	for TEST
	end for;
end CFG_TB;

