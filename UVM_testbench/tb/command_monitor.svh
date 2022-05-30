class command_monitor extends uvm_component;
  `uvm_component_utils(command_monitor);

  virtual dlx_if ddlx_if;
  uvm_analysis_port #(sequence_item) ap;

  function new (string name, uvm_component parent);
    super.new(name,parent);
  endfunction : new

  function void build_phase (uvm_phase phase);

    if (!uvm_config_db #(virtual dlx_if)::get(null, "*", "ddlx_if", ddlx_if))
      `uvm_fatal("DRIVER", "Could not retrieve the Interface ddlx_if");

    ap = new("ap", this);
  endfunction : build_phase

  function void connect_phase (uvm_phase phase);
    ddlx_if.command_monitor_h = this;
  endfunction : connect_phase

  function void write_to_monitor (instr_type_enum instr_type, bit [ir_size-1:0] ir_in, bit [op_code_size-1:0] opcode_field, bit [$clog2(rf_size):0] rs1, bit [$clog2(rf_size):0] rs2, bit [15:0] immediate);
    sequence_item instr;
    `uvm_info ("COMMAND MONITOR", $sformatf("MONITOR: Instr_type: %s - Instruction: %b - OpCode: %b - Rs1: %d - Rs2: %d - Imm: %d",
                                                         instr_type.name(), ir_in, opcode_field, rs1, rs2, immediate), UVM_HIGH);

    instr = new("instr");
    instr.instr_type  = instr_type;
    instr.ir_in       = ir_in;
    ap.write(instr);
  endfunction : write_to_monitor

endclass : command_monitor
