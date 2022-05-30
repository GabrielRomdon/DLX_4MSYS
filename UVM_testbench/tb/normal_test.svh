class normal_test extends uvm_test;
  `uvm_component_utils(normal_test);

  env               env_h;
  sequencer         sequencer_h;

  function void build_phase (uvm_phase phase);
    env_h = env::type_id::create("env_h", this);
  endfunction : build_phase

  function void end_of_elaboration_phase (uvm_phase phase);
    sequencer_h = env_h.sequencer_h;
  endfunction : end_of_elaboration_phase

  task run_phase (uvm_phase phase);
    normal_sequence normal_seq;
    normal_seq = new("normal_seq");

    phase.raise_objection(this);
    normal_seq.start(sequencer_h);
    phase.drop_objection(this);
  endtask : run_phase

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass
