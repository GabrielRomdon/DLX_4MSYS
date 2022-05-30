class normal_sequence extends uvm_sequence #(sequence_item);
  `uvm_object_utils(normal_sequence);

  sequence_item instr_seq;
  int i;

  function new(string name = "normal_sequence");
    super.new(name);
  endfunction : new

  task body();
    instr_seq = sequence_item::type_id::create("instr_seq");

	i = 0;
	while (max_PC > current_PC) begin : normal_loop
  	  start_item(instr_seq);
      finish_item(instr_seq);
	  i++;
	  if (i > 1000) max_PC = 0;
    end : normal_loop
  endtask : body

endclass : normal_sequence
