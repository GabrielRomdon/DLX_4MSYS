class scoreboard extends uvm_subscriber #(output_transaction);
  `uvm_component_utils(scoreboard);

  /* GLOBAL VARIABLES & CONSTANTS */
  // Create a matrix that holds a copy of the information stored in the register file and another for the data memory
  bit [rf_size-1:0][word-1:0]   cloned_regFile;
  bit [dram_size-1:0][word-1:0] cloned_datamem;
  bit [word-1:0]                cloned_PC = 20; 
  bit [word-1:0] 				predicted_PC = 0;
  bit [word-1:0] 				future_PC;
  bit [iram_size-1:0][ir_size-1:0] cloned_IRAM;
  int waiting = 0;
  
  uvm_tlm_analysis_fifo #(sequence_item) instr_f;

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase (uvm_phase phase);
    instr_f = new ("instr_f", this);
  endfunction : build_phase

  // This function performs two tasks:
  // 1. Obtain the predicted output according to the received instruction.
  // 2. Update the 'clone matrices' accordingly
  function output_transaction predict_output (sequence_item s_item);
    bit [$clog2(rf_size)-1:0]   rs1_addr;
    bit [$clog2(rf_size)-1:0]   rs2_addr;
    bit [$clog2(rf_size)-1:0]   rd_addr;
    bit signed [word-1:0]    rs1_val;
    bit signed [word-1:0]    rs2_val;
    bit signed [15:0] immediate;
    bit signed [25:0] j_immediate;
    bit [ir_size-1:0]       instruction;
    bit [op_code_size-1:0]  opcode;
    bit [func_size-1:0]     funct;
    output_transaction predicted;
    predicted = new("predicted");

    predicted.data_o = {word{1'b0}};
    instruction = s_item.ir_in;
    opcode = instruction[ir_size-1:ir_size-op_code_size];

    if (s_item.instr_type == i_type) begin // I-type instr
      rs1_addr  = instruction[msb_add_rd1:lsb_add_rd1];
      rd_addr   = instruction[msb_add_rd2:lsb_add_rd2];
      immediate = instruction[msb_add_rd3:0];
      rs1_val = cloned_regFile[rs1_addr];
    end else if (s_item.instr_type == r_type) begin // R-type instr
      rs1_addr  = instruction[msb_add_rd1:lsb_add_rd1];
      rs2_addr  = instruction[msb_add_rd2:lsb_add_rd2];
      rd_addr   = instruction[msb_add_rd3:lsb_add_rd3];
      funct     = instruction[lsb_add_rd3-1:0];
      rs1_val   = cloned_regFile[rs1_addr];
      rs2_val   = cloned_regFile[rs2_addr];
    end else if (s_item.instr_type == j_type) begin // J-type instruction
      j_immediate = instruction[ir_size-op_code_size-1:0];
    end else begin
      $fatal(1, "Unexpected instruction type. Does not correspond to any of the known instructions.");
    end

    case (opcode)
      rtype:  begin
        case (funct)
          rtype_sll : begin
            predicted.data_o = rs1_val << rs2_val[4:0];
            cloned_regFile[rd_addr] = predicted.data_o;
          end
          rtype_srl : begin
            predicted.data_o = rs1_val >> rs2_val[4:0];
            cloned_regFile[rd_addr] = predicted.data_o;
          end
          rtype_add : begin
            predicted.data_o = rs1_val + rs2_val;
            cloned_regFile[rd_addr] = predicted.data_o;
          end
          rtype_sub : begin
            predicted.data_o = rs1_val - rs2_val;
            cloned_regFile[rd_addr] = predicted.data_o;
          end
          rtype_and : begin
            predicted.data_o = rs1_val & rs2_val;
            cloned_regFile[rd_addr] = predicted.data_o;
          end
          rtype_or : begin
            predicted.data_o = rs1_val | rs2_val;
            cloned_regFile[rd_addr] = predicted.data_o;
          end
          rtype_xor : begin
            predicted.data_o = rs1_val ^ rs2_val;
            cloned_regFile[rd_addr] = predicted.data_o;
          end
          rtype_sne : begin
            predicted.data_o = rs1_val != rs2_val;
            cloned_regFile[rd_addr] = predicted.data_o;
          end
          rtype_sle : begin
            predicted.data_o = rs1_val <= rs2_val;
            cloned_regFile[rd_addr] = predicted.data_o;
          end
          rtype_sge : begin
            predicted.data_o = rs1_val >= rs2_val;
            cloned_regFile[rd_addr] = predicted.data_o;
          end
        endcase
      end
      jtype_j: begin
        predicted.data_o = signed'(cloned_PC) + j_immediate - 12;
        cloned_PC = predicted.data_o;
      end
      itype_beqz: begin
        if (rs1_val == 0) 
          predicted.data_o = signed'(cloned_PC) + immediate - 12;
        else
          predicted.data_o = signed'(cloned_PC);
        cloned_PC = predicted.data_o;
      end
      itype_bnez: begin
        if (rs1_val != 0)
          predicted.data_o = signed'(cloned_PC) + immediate - 12;
        else
          predicted.data_o = signed'(cloned_PC);
        cloned_PC = predicted.data_o;
      end
      itype_addi: begin
        predicted.data_o = rs1_val + immediate;
        cloned_regFile[rd_addr] = predicted.data_o;
      end
      itype_subi: begin
        predicted.data_o = rs1_val - immediate;
        cloned_regFile[rd_addr] = predicted.data_o;
      end
      itype_andi: begin
        predicted.data_o = rs1_val & unsigned'(immediate);
        cloned_regFile[rd_addr] = predicted.data_o;
      end
      itype_ori: begin
        predicted.data_o = rs1_val | unsigned'(immediate);
        cloned_regFile[rd_addr] = predicted.data_o;
      end
      itype_xori: begin
        predicted.data_o = rs1_val ^ unsigned'(immediate);
        cloned_regFile[rd_addr] = predicted.data_o;
      end
      itype_slli: begin
        predicted.data_o = rs1_val << immediate[4:0];
        cloned_regFile[rd_addr] = predicted.data_o;
      end
      itype_nop:
        predicted.data_o = 0;
      itype_srli: begin
        predicted.data_o = rs1_val >> immediate[4:0];
        cloned_regFile[rd_addr] = predicted.data_o;
      end
      itype_snei: begin
        predicted.data_o = rs1_val != immediate;
        cloned_regFile[rd_addr] = predicted.data_o;
      end
      itype_slei: begin
        predicted.data_o = rs1_val <= immediate;
        cloned_regFile[rd_addr] = predicted.data_o;
      end
      itype_sgei: begin
        predicted.data_o = rs1_val >= immediate;
        cloned_regFile[rd_addr] = predicted.data_o;
      end
      itype_lw: begin
        predicted.data_o = cloned_datamem[immediate + rs1_val];
        cloned_regFile[rd_addr] = predicted.data_o;
      end
      itype_sw: begin
        predicted.data_o = cloned_regFile[rd_addr]; 
        cloned_datamem[immediate + rs1_val] = predicted.data_o; 
      end
    endcase

    // Increment Program Counter
    cloned_PC = cloned_PC + 4;

    return predicted;

  endfunction : predict_output

  /* This function will read the .mem file and store its content in the global matrix cloned_IRAM  */
  function int read_mem_file();

	int i = 0;
  	int fd;
	bit [ir_size-1:0] instr;
	string data_string;

  	fd = $fopen ("./../asm_example/UVM_test.mem", "r");
	if (!fd) begin
		`uvm_error("FLOW CHECKER", {"Failed to open .mem file"});
	end else begin
  		while(!$feof(fd)) begin
			$fscanf(fd, "%h\n", instr);
			cloned_IRAM[i] <= instr;
			$sformat(data_string, "%d : %h", i, instr);
			`uvm_info ("FLOW CHECKER", {"Reading file line ", data_string}, UVM_HIGH);
			i++;
  		end
	end

	$fclose(fd);
	return i;
	
  endfunction : read_mem_file;
  
  /* This function will:
	 1.check if the fetched instruction is the expected one
	 2.compute the next fetched instruction in the case of a jump or branch instruction */
  function predict_instr_flow (sequence_item s_item);

    bit [ir_size-1:0] instruction;
    bit signed [15:0] immediate;
    bit signed [25:0] j_immediate;
	bit [ir_size-1:ir_size-op_code_size] opcode;
    bit [$clog2(rf_size)-1:0] rs1_addr;
	bit signed [word-1:0] rs1_val;

	instruction = s_item.ir_in;
	predicted_PC = predicted_PC + 1;
	current_PC = predicted_PC; //used by the sequencer to stop the test

	if(cloned_IRAM[predicted_PC-1] != instruction)
	  `uvm_error("FLOW CHECKER", {"FAIL: flow violation"})
   	else
   	  `uvm_info ("FLOW CHECKER", {"PASS: flow respected"}, UVM_HIGH)

	//even if the previous check fails, the correct flow will be computed using instr from the mem file
	instruction = cloned_IRAM[predicted_PC-1];
	opcode = instruction[ir_size-1:ir_size-op_code_size];

	if (waiting > 0) waiting++;
	if (waiting == 4) begin
		predicted_PC = future_PC;
		waiting = 0;
	end

	case (opcode)
      	jtype_j: begin
			if(waiting==0) waiting = 1; //thanks to this if the first jump will be considered only
			j_immediate = instruction[ir_size-op_code_size-1:0];
			future_PC = signed'(predicted_PC) + signed'(j_immediate)/4;
		end
      	itype_beqz: begin
			immediate = instruction[msb_add_rd3:0];
			rs1_addr = instruction[msb_add_rd1:lsb_add_rd1];
			rs1_val = cloned_regFile[rs1_addr];
        	if (rs1_val == 0) begin
				if(waiting==0) waiting = 1;
        		future_PC = signed'(predicted_PC) + signed'(immediate)/4;
			end
      	end
      	itype_bnez: begin
			immediate = instruction[msb_add_rd3:0];
			rs1_addr = instruction[msb_add_rd1:lsb_add_rd1];
			rs1_val = cloned_regFile[rs1_addr];
        	if (rs1_val != 0) begin
				if(waiting==0) waiting = 1;
        		future_PC = signed'(predicted_PC) + signed'(immediate)/4;
			end
      end
    endcase
	
  endfunction : predict_instr_flow

  function void write (output_transaction t);

    string              data_str;
    sequence_item       instr;
    output_transaction  predicted;

    if(!instr_f.try_get(instr))
      $fatal(1, "Missing command in self checker");

    predicted = predict_output(instr);

    data_str = {                    instr.convert2string(),
                 " ==>  Actual " ,      t.convert2string(),
                 "/Predicted ", predicted.convert2string()};

    if (!predicted.compare(t))
      `uvm_error("SELF CHECKER", {"FAIL: ", data_str})
    else
      `uvm_info ("SELF CHECKER", {"PASS: ", data_str}, UVM_HIGH)

	predict_instr_flow(instr);

  endfunction : write

endclass : scoreboard
