/* Interface used in the ALU testbench. Contains the signals and also the
* clock and reset startop and generation */
import myTypes::*;

interface alu_if #(parameter NBIT = 8);

    /* Definiton of interface signals */
    logic               clk;
    logic               rst_n;
    aluoptype           alu_op;
    logic [NBIT-1:0]    alu_in_a;
    logic [NBIT-1:0]    alu_in_b;
    logic [NBIT-1:0]    alu_out;

    /* Definition of interface modports */
    
    // Modport for the ALU (DUT)
    modport alu_port (
        input   alu_op,
        input   alu_in_a,
        input   alu_in_b,
        output  alu_out
    );

    // Modport for the coverage
    modport alu_coverage_port (
        input   clk,
        input   alu_op,
        input   alu_in_a,
        input   alu_in_b
    );

    // Modport for the scoreboard
    modport alu_scoreboard_port (
        input   clk,
        input   rst_n,
        input   alu_op,
        input   alu_in_a,
        input   alu_in_b,
        input   alu_out
    );

    /* CLOCK AND RESET GENERATION */
    initial begin
        clk     = 1'b0;
        rst_n   = 1'b0;

        // Release the reset after 20ns
        #20ns
        rst_n   = 1'b1;

        // Clock toggle
        forever #10ns clk = ~clk;
    end

endinterface
