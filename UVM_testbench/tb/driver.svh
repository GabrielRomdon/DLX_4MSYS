class driver extends uvm_driver #(sequence_item);
  `uvm_component_utils(driver);

  virtual dlx_if ddlx_if;

  function void build_phase (uvm_phase phase);
    if(!uvm_config_db #(virtual dlx_if)::get(null, "*", "ddlx_if", ddlx_if))
      `uvm_fatal("DRIVER", "Could not retrieve the Interface ddlx_if");
  endfunction : build_phase

  task run_phase (uvm_phase phase);
    sequence_item s_item;

    forever begin : s_item_loop
      seq_item_port.get_next_item(s_item);
      ddlx_if.wait_one_cycle();
      seq_item_port.item_done();
    end : s_item_loop
  endtask : run_phase

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : driver
