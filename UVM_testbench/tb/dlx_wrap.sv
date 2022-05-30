/* Wrapper for the DLX processor. Useful to connect with the interface and to 
    map from VHDL to SystemVerilog */

import mytypes::*;

module dlx_wrap 
     (  input               clk,
        input               rst
     );

    DLX #(word, ir_size) DLX_DUT (
        .CLK              (clk),
        .RST              (rst)
    );

endmodule
