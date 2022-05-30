interface dlx_if;
  import dlx_pkg::*;
  import mytypes::*;

  bit               clk;
  bit               rst;
  bit [ir_size-1:0] instr_reg [4:0];
  bit [ir_size-1:0] current_instr_reg;
  bit [5:0]         instrOpcode;
  instr_type_enum   instrType;
  bit [$clog2(rf_size)-1:0] rs1;
  bit [$clog2(rf_size)-1:0] rs2;
  bit [$clog2(rf_size)-1:0] rd;
  bit [15:0] imm;
  bit [word-1:0]  reg1_val;
  int               sw_addr;
  bit [word-1:0]  data_out;
  bit [word-1:0]  pc_bus;
  bit [3:0]       start_work_counter; // Counter that when arrives to 3 tells that the processor is working

  // Task for synchronizing the driver with the test
  task wait_one_cycle ();
    @(posedge clk);
  endtask : wait_one_cycle

  // Command monitor thread
  command_monitor command_monitor_h;

  // Procedure for sampling (and delaying) the instruction by using an internal signal of the processor
  always @(posedge clk) begin : sampling_procedure
    instr_reg[4:1]  <= instr_reg[3:0];
    instr_reg[0]    <= top.DUT.DLX_DUT.next_IW;
  end : sampling_procedure

  // Procedure for sending the fetched instruction through the command monitor
  always @(posedge clk) begin : command_monitor_thd
    current_instr_reg = instr_reg[4];
    //$display("PC from if: %x", top.DUT.DLX_DUT.current_PC);
    
    // Obtaining the instruction type and extracting the relevant values
    instrOpcode = current_instr_reg[ir_size-1:ir_size-op_code_size];

    case (instrOpcode)
      6'h00 :   instrType = r_type;
      6'h02 :   instrType = j_type;
      6'h03 :   instrType = j_type;
      default : instrType = i_type;
    endcase

    if ( instrType == i_type ) begin
      rs1 = current_instr_reg[msb_add_rd1:lsb_add_rd1];
      rd  = current_instr_reg[msb_add_rd2:lsb_add_rd2];
      imm = current_instr_reg[msb_add_rd3:0];
    end else if ( instrType == r_type ) begin
      rs1 = current_instr_reg[msb_add_rd1:lsb_add_rd1];
      rs2 = current_instr_reg[msb_add_rd2:lsb_add_rd2];
      rd  = current_instr_reg[msb_add_rd3:lsb_add_rd3];
    end else if (instrType == j_type ) begin
      imm = current_instr_reg[ir_size-op_code_size-1:0];
    end else begin
      $fatal(1, "Unexpected instruction type. Does not correspond to any of the known instructions.");
    end

    if ( start_work_counter == 8)
      command_monitor_h.write_to_monitor(instrType, current_instr_reg, instrOpcode, rs1, rs2, imm);
  end : command_monitor_thd

  // Output monitor thread
  output_monitor output_monitor_h;

  always @(posedge clk) begin : output_monitor_thread
	
    /* Obtain relevant word and set data_out */
    if ( instrType == i_type ) begin
      if ( instrOpcode == itype_sw ) begin
        reg1_val  = top.DUT.DLX_DUT.DP.RF.REGISTERS[int'(rs1)];
        sw_addr   = int'(reg1_val + imm);
        data_out = top.DUT.DLX_DUT.DP.RAM.DATAMEM[sw_addr];
      end else if ( instrOpcode == itype_nop ) begin
        data_out = 0;
      end else if ( instrOpcode == itype_beqz || instrOpcode == itype_bnez ) begin
        data_out = top.DUT.DLX_DUT.current_PC;
      end else begin
        data_out = top.DUT.DLX_DUT.DP.RF.REGISTERS[int'(rd)];
      end
    end else if ( instrType == r_type ) begin
      data_out = top.DUT.DLX_DUT.DP.RF.REGISTERS[int'(rd)];
    end else if ( instrType == j_type ) begin
      data_out = top.DUT.DLX_DUT.current_PC;
    end

    if ( start_work_counter == 8)
      output_monitor_h.write_to_monitor(data_out);
  end : output_monitor_thread

  // Counter to avoid problems with the timing of the first instruction
  always @(posedge clk) begin : counter
    if ( !rst )
      start_work_counter <= 0;
    else if (start_work_counter < 8)
      start_work_counter <= start_work_counter + 1;
    else
      start_work_counter <= start_work_counter;
  end : counter

  // Clock generation
  initial begin
    clk = 0;
    fork
      forever begin
        #100;
        clk = ~clk;
      end
    join_none
  end

  // Set reset to '1' since it's active-low
  initial begin
    rst = 0;
    #200
    rst = 1;
  end

endinterface : dlx_if
