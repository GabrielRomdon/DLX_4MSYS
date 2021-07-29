/* Testbench for the ALU, using the class and the interface */

`include "alu_tester.svh"

import myTypes::*;

module alu_tb;

    // Define the number of bits
    localparam NBITS    = 8;
    localparam NUM_OPS  = 1000;

    // Instantiate the ALU interface
    alu_if #(NBITS)     aif();

    // Instantiate the ALU wrapper
    alu_wrap #(NBITS)   aw(aif.alu_port);

    // Instantiate the ALU covergroup
    alu_coverage #(NBITS)   alu_cv(aif.alu_coverage_port);
    
    // Instantiate the ALU scoreboard
    alu_scoreboard #(NBITS) alu_scoreb(aif.alu_scoreboard_port);
    
    // Instantiate a tester object
    alu_tester #(
        .NBITS(NBITS),
        .NUM_OPS(NUM_OPS)
    ) tst;

    // Run the test
    initial begin 
        // Call the constructor of the test
        tst = new(aif);

        $display("Launching ALU test (no barrel)...");
        fork
            tst.run_test();
        join
        
        $display("ALU test completed!");
        $display("Coverage = %0.2f %% \n", alu_cv.oc.get_inst_coverage());

        $stop;
    end

endmodule
