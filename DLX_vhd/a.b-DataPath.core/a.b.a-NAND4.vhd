-- NAND4 - 4 input NAND gate
-- ----------------------------------------------------------
-- Editor(s)    : Coralie Allioux, Gabriel Romero, Simone Valente
-- Last updated : 06/Sep/2021

library IEEE;
use IEEE.std_logic_1164.all;

entity NAND4 is
  port    ( A: IN std_logic; -- Input A
            B: IN std_logic; -- Input B
            C: IN std_logic; -- Input C
            D: IN std_logic; -- Input D
            Y: OUT std_logic); -- Output
end NAND4;

architecture BEHAVIOUR of NAND4 is

begin

  Y <= NOT( A AND B AND C AND D);

end BEHAVIOUR;

