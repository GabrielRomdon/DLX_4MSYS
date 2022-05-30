package dlx_pkg;
  import uvm_pkg::*;
  import mytypes::*;
  `include "uvm_macros.svh"

  typedef enum int {
    i_type = 1,
    r_type = 2,
    j_type = 3
  } instr_type_enum;

  int max_PC, current_PC;

  `include "sequence_item.svh"
  typedef uvm_sequencer #(sequence_item) sequencer;

  `include "normal_sequence.svh"

  `include "output_transaction.svh"
  `include "coverage.svh"
  `include "scoreboard.svh"
  `include "driver.svh"
  `include "command_monitor.svh"
  `include "output_monitor.svh"
   
  `include "env.svh"

  `include "normal_test.svh"
   
endpackage : dlx_pkg
