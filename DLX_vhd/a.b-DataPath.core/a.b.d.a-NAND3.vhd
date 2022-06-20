-- NAND3 - 3 input NAND gate
-- ----------------------------------------------------------
-- Editor(s)    : Coralie Allioux, Gabriel Romero, Simone Valente
-- Last updated : 04/Jun/2022

library IEEE;
use IEEE.std_logic_1164.all;

entity NAND3 is
  port    ( A: IN std_logic; -- Input A
            B: IN std_logic; -- Input B
            C: IN std_logic; -- Input C
            Y: OUT std_logic); -- Output
end NAND3;

architecture BEHAVIOUR of NAND3 is

begin

  Y <= NOT( A AND B AND C);

end BEHAVIOUR;

