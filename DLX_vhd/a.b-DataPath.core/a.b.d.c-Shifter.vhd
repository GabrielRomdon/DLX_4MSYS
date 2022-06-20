-- Barrel Shifter
-- ----------------------------------------------------------
-- Editor(s)    : Coralie Allioux, Gabriel Romero, Simone Valente
-- Last updated : 04/Jun/2022
-- Features     : Based on T2 shifter. Expects only N=32

library IEEE;
use IEEE.std_logic_1164.all;
use work.myTypes.all;

entity BARREL_SHIFTER is
  generic ( N : integer := WORD);
  port   ( CONF:         IN std_logic; -- Input for selecting either left (CONF=0) or right (CONF=1) TODO: Later this will represent either arithmetic or logic also
           DATA1, DATA2: IN std_logic_vector(N-1 downto 0); -- Data inputs
           OUTPUT:       OUT std_logic_vector(N-1 downto 0)); -- Data outputs
end BARREL_SHIFTER;

architecture BEHAVIOR of BARREL_SHIFTER is

  -- Signal declaration
  signal MASK0  : std_logic_vector(N+7 downto 0);
  signal MASK8  : std_logic_vector(N+7 downto 0);
  signal MASK16 : std_logic_vector(N+7 downto 0);
  signal MASK24 : std_logic_vector(N+7 downto 0);
  signal COARSE : std_logic_vector(N+7 downto 0);
  signal SL_OUT : std_logic_vector(N-1 downto 0);
  signal SR_OUT : std_logic_vector(N-1 downto 0);

begin

-------------------------------------------
-- Create coarse masks --------------------
-------------------------------------------
MASK0  <= (DATA1(31 downto 0) & ( 7 downto 0 => '0')) when CONF = '0' else (( 7 downto 0 => '0') &  DATA1(N-1 downto  0));
MASK8  <= (DATA1(23 downto 0) & (15 downto 0 => '0')) when CONF = '0' else ((15 downto 0 => '0') &  DATA1(N-1 downto  8));
MASK16 <= (DATA1(15 downto 0) & (23 downto 0 => '0')) when CONF = '0' else ((23 downto 0 => '0') &  DATA1(N-1 downto 16));
MASK24 <= (DATA1( 7 downto 0) & (31 downto 0 => '0')) when CONF = '0' else ((31 downto 0 => '0') &  DATA1(N-1 downto 24));

-------------------------------------------
-- Coarse mux -----------------------------
-------------------------------------------
with DATA2(4 downto 3) select
  COARSE  <=  MASK0  when "00",
              MASK8  when "01",
              MASK16 when "10",
              MASK24 when "11",
              (others => '0') when others;

-------------------------------------------
-- Fine mux -------------------------------
-------------------------------------------
-- Using one mux for the shift left and one mux for the shift right
with DATA2(2 downto 0) select
  SL_OUT  <= COARSE(N+7 downto 8) when "000",
             COARSE(N+6 downto 7) when "001",
             COARSE(N+5 downto 6) when "010",
             COARSE(N+4 downto 5) when "011",
             COARSE(N+3 downto 4) when "100",
             COARSE(N+2 downto 3) when "101",
             COARSE(N+1 downto 2) when "110",
             COARSE(N+0 downto 1) when others;

with DATA2(2 downto 0) select
  SR_OUT  <= COARSE(N-1 downto 0) when "000",
             COARSE(N+0 downto 1) when "001",
             COARSE(N+1 downto 2) when "010",
             COARSE(N+2 downto 3) when "011",
             COARSE(N+3 downto 4) when "100",
             COARSE(N+4 downto 5) when "101",
             COARSE(N+5 downto 6) when "110",
             COARSE(N+6 downto 7) when others;

-- The final output is decided using another mux along with the input CONF
OUTPUT <= SL_OUT when CONF = '0' else SR_OUT;

end BEHAVIOR;
