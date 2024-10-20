class dest_config extends uvm_object;

`uvm_object_utils (dest_config)

function new(string name ="dest_config");
super.new(name);
endfunction

uvm_active_passive_enum is_active;
virtual dest_if vif;

int no_of_transactions;

endclass

