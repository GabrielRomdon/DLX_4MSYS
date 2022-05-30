class coverage extends uvm_subscriber #(sequence_item);
  `uvm_component_utils(coverage)

  instr_type_enum             instr_type;
  bit [op_code_size-1:0]      opcode_field;
  bit [$clog2(rf_size)-1:0]   rs1;
  bit [$clog2(rf_size)-1:0]   rs2;
  bit [15:0]                  immediate;
  int                        instr_coverage;

  covergroup IR_covg;

    coverpoint instr_type{
      bins itype = {i_type};
      bins rtype = {r_type};
      bins jtype = {j_type};
    }
    
    coverpoint opcode_field{
       bins op_code= {[0:62]};
    }
    coverpoint rs1 {
      bins reg_1 = {[0:31]};
    }

    coverpoint rs2 {
      bins reg_2 = {[0:31]};
    }

    coverpoint immediate{
      bins imm = {[0:177777]};
    }

    
  endgroup
 

  function new (string name, uvm_component parent);
    super.new(name, parent);
    IR_covg = new();
  endfunction : new

  function void write(sequence_item t);
    instr_type = t.instr_type;
    opcode_field=t.opcode_field;
    rs1 = t.rs1;
    rs2 = t.rs2;
    immediate = t.immediate;
    IR_covg.sample();
  endfunction : write

  function void extract_phase(uvm_phase phase);
    instr_coverage = IR_covg.get_coverage();
  endfunction: extract_phase

  function void report_phase(uvm_phase phase);
    `uvm_info("REPORT", $sformatf("Instruction coverage is %d", instr_coverage), UVM_LOW);
  endfunction: report_phase

endclass : coverage
