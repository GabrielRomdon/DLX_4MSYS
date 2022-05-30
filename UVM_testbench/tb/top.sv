module top;
  import uvm_pkg::*;
  import dlx_pkg::*;
  import mytypes::*;
  
// `include "dlx_macros.svh"
  `include "uvm_macros.svh"

  dlx_if   ddlx_if();
  dlx_wrap DUT (.clk              (ddlx_if.clk),
                .rst              (ddlx_if.rst));

  initial begin
    uvm_config_db #(virtual dlx_if)::set(null, "*", "ddlx_if", ddlx_if);
    run_test();
  end

endmodule : top  
