class env extends uvm_env;
  `uvm_component_utils(env);

  sequencer       sequencer_h;
  coverage        coverage_h;
  scoreboard      scoreboard_h;
  driver          driver_h;
  command_monitor command_monitor_h;
  output_monitor  output_monitor_h;

  function new (string name, uvm_component parent);
     super.new(name,parent);
  endfunction : new

  function void build_phase (uvm_phase phase);
    //// stimulus
    sequencer_h       = new("sequencer_h", this);
    driver_h          = driver::type_id::create("driver_h", this);
    // monitor
    command_monitor_h = command_monitor::type_id::create("command_monitor_h", this);
    output_monitor_h  = output_monitor::type_id::create("output_monitor_h", this);
    // analysis
    coverage_h        = coverage::type_id::create("coverage_h", this);
    scoreboard_h      = scoreboard::type_id::create("scoreboard", this);
	// read the .mem file and store its length in a variable from the pkg
	max_PC = scoreboard_h.read_mem_file();
  endfunction : build_phase

  function void connect_phase (uvm_phase phase);
    driver_h.seq_item_port.connect(sequencer_h.seq_item_export);

    command_monitor_h.ap.connect(coverage_h.analysis_export);
    command_monitor_h.ap.connect(scoreboard_h.instr_f.analysis_export);
    output_monitor_h.ap.connect(scoreboard_h.analysis_export);
  endfunction : connect_phase

endclass : env
