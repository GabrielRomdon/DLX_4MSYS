class output_monitor extends uvm_component;
  `uvm_component_utils(output_monitor);

  virtual dlx_if ddlx_if;
  uvm_analysis_port #(output_transaction) ap;

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase (uvm_phase phase);
    if(!uvm_config_db #(virtual dlx_if)::get(null, "*", "ddlx_if", ddlx_if))
      `uvm_fatal("DRIVER", "Could not retrieve the Interface ddlx_if");
    ap = new("ap", this);
  endfunction : build_phase

  function void connect_phase (uvm_phase phase);
    ddlx_if.output_monitor_h = this;
  endfunction : connect_phase

  function void write_to_monitor ([word-1:0] data_out);
    output_transaction output_t;
    output_t = new("output_t");
    output_t.data_o  = data_out;
    ap.write(output_t);
  endfunction : write_to_monitor

endclass : output_monitor  
