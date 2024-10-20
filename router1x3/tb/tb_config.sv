class tb_config extends uvm_object;
`uvm_object_utils (tb_config)

bit [1:0] address;
bit has_sb;
bit has_sagent;
bit has_dagent;
bit has_virtual_sequencer;
int no_of_transactions;
int no_of_destinations;
source_config s_cfg;
dest_config d_cfg[];

function new(string name="tb_config");
super.new(name);
endfunction

endclass
