class output_transaction extends uvm_transaction;

  bit [word-1:0]  data_o;

  function new (string name = "");
    super.new(name);
  endfunction : new

  function string convert2string();
    string s;
    s = $sformatf("DataOut: %h", data_o);
    return s;
  endfunction : convert2string

  function bit do_compare (uvm_object rhs, uvm_comparer comparer);
    output_transaction  RHS;
    bit                 same;
    assert (rhs != null) else
      $fatal(1,"Tried to compare null transaction");

    same = super.do_compare(rhs, comparer);

    $cast(RHS, rhs);
    same = (data_o == RHS.data_o) && same;
    return same;
  endfunction : do_compare

endclass : output_transaction
