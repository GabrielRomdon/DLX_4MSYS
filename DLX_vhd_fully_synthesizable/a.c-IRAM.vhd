library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.myTypes.all;


-- Instruction memory for DLX
-- Memory filled by a process which reads from a file
-- file name is "test_jump_label_no_hazard.mem"
entity IRAM is
  generic (
    RAM_DEPTH : integer := IRAM_SIZE;
    I_SIZE : integer := IR_SIZE);
  port (
    Rst  : in  std_logic;
    Addr : in  std_logic_vector(I_SIZE - 1 downto 0);
    Dout : out std_logic_vector(I_SIZE - 1 downto 0)
    );

end IRAM;

architecture IRam_Bhe of IRAM is

  type RAMtype is array (0 to RAM_DEPTH - 1) of integer;-- std_logic_vector(I_SIZE - 1 downto 0);

  signal IRAM_mem : RAMtype;
  signal Addr_shifted : std_logic_vector(I_SIZE - 1 downto 0);

begin  -- IRam_Bhe

  Addr_shifted <= std_logic_vector(shift_right(ieee.numeric_std.unsigned(Addr), 2)); -- Divided by 4
  Dout <= conv_std_logic_vector(IRAM_mem(conv_integer(ieee.std_logic_arith.unsigned(Addr_shifted))),I_SIZE);

  -- purpose: This process is in charge of filling the Instruction RAM with the firmware
  -- type   : combinational
  -- inputs : Rst
  -- outputs: IRAM_mem
  FILL_MEM_P: process (Rst)
    file mem_fp: text;
    variable file_line : line;
    variable index : integer := 0;
    variable tmp_data_u : std_logic_vector(I_SIZE-1 downto 0);
  begin  -- process FILL_MEM_P
    if (Rst = '0') then
      file_open(mem_fp,"../asm_example/simple_test.mem",READ_MODE);
      while (not endfile(mem_fp)) loop
        readline(mem_fp,file_line);
        hread(file_line,tmp_data_u);
        IRAM_mem(index) <= conv_integer(ieee.std_logic_arith.unsigned(tmp_data_u));       
        index := index + 1;
      end loop;
    end if;
  end process FILL_MEM_P;

end IRam_Bhe;
