class source_config extends uvm_object;

`uvm_object_utils (source_config)

function new(string name ="source_config");
super.new(name);
endfunction

uvm_active_passive_enum is_active;
virtual source_if vif;

int no_of_transactions;

endclass
