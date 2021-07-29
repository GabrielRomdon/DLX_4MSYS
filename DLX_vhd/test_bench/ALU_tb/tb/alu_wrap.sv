/* Wrapper for the ALU circuit. Useful to connect with the interface and to 
* map from VHDL to SystemVerilog */

module alu_wrap #(parameter NBIT = 8) (
    alu_if.alu_port alu_port //Port for connecting from interface
);

    ALU #(NBIT) ALU_DUT (
        .FUNC   (alu_port.alu_op),
        .DATA1  (alu_port.alu_in_a), 
        .DATA2  (alu_port.alu_in_b),
        .OUTALU (alu_port.alu_out)
    );

endmodule
