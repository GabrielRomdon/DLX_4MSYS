class sequence_item extends uvm_sequence_item;
  `uvm_object_utils(sequence_item);

  rand instr_type_enum            instr_type;
  rand bit [func_size-1:0]        func_field;
  rand bit [op_code_size-1:0]     opcode_field;
  rand bit [$clog2(rf_size)-1:0]   rs1;
  rand bit [$clog2(rf_size)-1:0]   rs2;
  rand bit [$clog2(rf_size)-1:0]   rd;
  rand bit [half_word-1:0]         immediate;
  rand aluoptype                  alu_op;
  // Fields for using in the analysis port
  bit [ir_size-1:0] ir_in;

  function new (string name = "");
    super.new(name);
  endfunction : new

  function string convert2string();
    string  s;
    s = $sformatf("Function type: %d",
                            instr_type);
    return s;
  endfunction : convert2string

endclass : sequence_item
