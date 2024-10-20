class virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);

`uvm_component_utils (virtual_sequencer)

source_sequencer s_seqrh;
dest_sequencer d_seqrh[];

tb_config m_cfg;




function new(string name="virtual_sequencer",uvm_component parent);
super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
if(!uvm_config_db #(tb_config) :: get(this,"","tb_config",m_cfg))
	`uvm_fatal(get_type_name(),"getting is failed")

d_seqrh = new[m_cfg.no_of_destinations];

endfunction 

endclass







