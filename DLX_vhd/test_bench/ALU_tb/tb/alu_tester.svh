/* Classes for the alu test */

import myTypes::*;

class alu_tester #(
    parameter NBITS     = 8,
    parameter NUM_OPS   = 1000
);

    /* Variables */
    virtual interface alu_if #(NBITS) vaif;
    randc aluoptype           alu_op; //Using randc for the operation type. All the operations will appear the same number of times
    rand logic [NBITS-1:0]  alu_in_a;
    rand logic [NBITS-1:0]  alu_in_b;

    /* Contraints for the variables */
    // Constraint to avoid overflow when multiplying
    //constraint product_operands_constraint  { if (alu_op == mult)
    //                                            alu_in_a < 2**(NBITS/2);
    //                                            alu_in_b < 2**(NBITS/2);
    //                                        }

    // Constraint to avoid the shift and rotate to be larger than the number of bits
    constraint shift_rotate_operandB_constraint { if (alu_op == srls || 
                                                      alu_op == slls)
                                                        alu_in_b < NBITS;
                                                }


    /* Methods */
    // Constructor
    function new(virtual interface alu_if #(NBITS) interf);
        vaif = interf;
    endfunction

    // Test taks
    task run_test();
        repeat (NUM_OPS) begin
            @(negedge vaif.clk);

            randomize_alu();
        end
    endtask

    // Test functions
    function void randomize_alu();
        //Randomize operations
        assert (this.randomize())
        else    $error("ERROR while randomizing ALU inputs");

        vaif.alu_op = alu_op;
        vaif.alu_in_a  = alu_in_a;
        vaif.alu_in_b  = alu_in_b;
    endfunction

endclass

