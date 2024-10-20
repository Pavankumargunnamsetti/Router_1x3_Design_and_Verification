class source_agent extends uvm_agent;

`uvm_component_utils (source_agent)

source_driver drvh;
source_monitor monh;
source_sequencer seqrh;

source_config m_cfg;



function new(string name="source_agent",uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
 if(!uvm_config_db #(source_config) :: get(this,"","source_config",m_cfg))
		`uvm_fatal(get_type_name(),"getting is failed")

monh = source_monitor :: type_id :: create("monh",this);
if(m_cfg.is_active == UVM_ACTIVE)
begin
	drvh = source_driver :: type_id :: create("drvh",this);
	seqrh = source_sequencer :: type_id :: create("seqrh",this);
end
endfunction


function void connect_phase(uvm_phase phase);
if(m_cfg.is_active == UVM_ACTIVE)
	drvh.seq_item_port.connect(seqrh.seq_item_export);
endfunction


endclass
