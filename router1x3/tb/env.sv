class env extends uvm_env;

`uvm_component_utils (env)
tb_config m_cfg;
source_agent_top s_top;
dest_agent_top d_top;
virtual_sequencer v_sequencer;
router_sb sb;
function new(string name="env",uvm_component parent);
super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);

if(!uvm_config_db #(tb_config) :: get(this,"","tb_config",m_cfg))
	`uvm_fatal(get_type_name(),"getting is failed")
if(m_cfg.has_sagent)
	s_top = source_agent_top :: type_id :: create("s_top",this);
if(m_cfg.has_dagent)
	d_top = dest_agent_top :: type_id :: create("d_top",this);

if(m_cfg.has_virtual_sequencer)
	v_sequencer = virtual_sequencer :: type_id :: create("v_sequencer",this);
if(m_cfg.has_sb)
	sb = router_sb :: type_id :: create("sb",this);

endfunction

function void connect_phase(uvm_phase phase);

if(m_cfg.has_virtual_sequencer)
	begin
		v_sequencer.s_seqrh = s_top.agenth.seqrh;
		foreach(v_sequencer.d_seqrh[i])
			v_sequencer.d_seqrh[i] = d_top.agenth[i].seqrh;
	end

if(m_cfg.has_sb)
	begin
		if(m_cfg.has_sagent)
		begin
		s_top.agenth.monh.monitor_port.connect(sb.fifo_srh.analysis_export);
		end
		
		begin
		if(m_cfg.has_dagent)
		for(int i=0;i<m_cfg.no_of_destinations;i++)
			d_top.agenth[i].monh.monitor_port.connect(sb.fifo_drh[i].analysis_export);
		end
	end
endfunction

endclass
