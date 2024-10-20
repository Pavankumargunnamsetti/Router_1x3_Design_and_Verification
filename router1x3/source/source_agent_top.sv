class source_agent_top extends uvm_agent;
`uvm_component_utils(source_agent_top)
tb_config m_cfg;
source_agent agenth;

function new(string name="source_agent_top",uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);

if(!uvm_config_db #(tb_config) :: get(this,"","tb_config",m_cfg))
	`uvm_fatal(get_type_name(),"getting is failed")

if(m_cfg.has_sagent)
begin
	agenth = source_agent :: type_id :: create("agenth",this);
	uvm_config_db #(source_config) :: set(this,"agenth*","source_config",m_cfg.s_cfg);
end

endfunction

endclass
