/* This module contains the scoreboard for the test of the ALU 
    Here we check that the value returned by the DUT corresponds 
    to the expected value */

import myTypes::*;

module alu_scoreboard #(parameter NBIT = 8) (
    alu_if.alu_scoreboard_port port // Port for connecting from interface
);

    /* Check the result of the asynchronous ALU using the rising edge of the clock
        (because the input data is set on the falling edge) */
    always @(posedge port.clk) begin
        logic [NBIT-1:0]    predicted_result;

        case (port.alu_op)
            adds:       predicted_result = port.alu_in_a + port.alu_in_b;
            subs:       predicted_result = port.alu_in_a - port.alu_in_b;
            ands:       predicted_result = port.alu_in_a & port.alu_in_b;
            ors:        predicted_result = port.alu_in_a | port.alu_in_b;
            xors:       predicted_result = port.alu_in_a ^ port.alu_in_b;
            sle:        predicted_result = port.alu_in_a <= port.alu_in_b;
            sge:        predicted_result = port.alu_in_a >= port.alu_in_b;
            sne:        predicted_result = port.alu_in_a != port.alu_in_b;
            srls:       predicted_result = port.alu_in_a >> port.alu_in_b;
            slls:       predicted_result = port.alu_in_a << port.alu_in_b;
            default:    predicted_result = {NBIT{1'b0}};
        endcase

        if ( predicted_result != port.alu_out && port.rst_n == 1'b1)
            $error ("ERROR: Operation incorrect: A: %0h B: %0h  op: %s result: %0h; predicted %0h", 
                    port.alu_in_a, port.alu_in_b, port.alu_op.name(), port.alu_out, predicted_result);
    end
endmodule : alu_scoreboard
