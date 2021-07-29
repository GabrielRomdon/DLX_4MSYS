/* This file contains the covergroups for the test of the ALU 
    The purpose is to check that all functions are being covered */

import myTypes::*;

module alu_coverage #(parameter NBIT = 8) (
    alu_if.alu_coverage_port port //Port for connecting from interface
);

    /* Definition of internal signals that correspond to the interface */
    aluoptype           op;
    logic [NBIT-1:0]    in_a;
    logic [NBIT-1:0]    in_b;
    logic [NBIT-1:0]    out;

    /* Definition of covergroup and coverpoints */
    // This covergroup corresponds to the check that all operations are covered
    covergroup operation_coverg;
        coverpoint op {
            bins op_bin[] = {[adds:slls]};
        }
    endgroup // End covergroup operation_coverg

    /* Creating the covergroup objects and connecting the signals from the interface into the signals of the covergroup */
    // Instantiate a covergroup
    operation_coverg oc;

    initial begin : coverage_block
        oc = new(); // Initialize the covergroup
        forever begin : sampling_block
            @(posedge port.clk) // Using posedge for sampling because the values change on the negedge
            in_a    = port.alu_in_a;
            in_b    = port.alu_in_b;
            op      = port.alu_op;
            oc.sample();
        end : sampling_block
    end : coverage_block

endmodule: alu_coverage
