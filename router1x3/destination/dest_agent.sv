class dest_agent extends uvm_agent;

`uvm_component_utils (dest_agent)

dest_driver drvh;
dest_monitor monh;
dest_sequencer seqrh;

dest_config m_cfg;



function new(string name="dest_agent",uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
 if(!uvm_config_db #(dest_config) :: get(this,"","dest_config",m_cfg))
		`uvm_fatal(get_type_name(),"getting is failed")

monh = dest_monitor :: type_id :: create("monh",this);
if(m_cfg.is_active == UVM_ACTIVE)
begin
	drvh = dest_driver :: type_id :: create("drvh",this);
	seqrh = dest_sequencer :: type_id :: create("seqrh",this);
end
endfunction


function void connect_phase(uvm_phase phase);
if(m_cfg.is_active == UVM_ACTIVE)
	drvh.seq_item_port.connect(seqrh.seq_item_export);
endfunction


endclass

