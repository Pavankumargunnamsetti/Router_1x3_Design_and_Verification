class dest_agent_top extends uvm_agent;
`uvm_component_utils(dest_agent_top)

dest_agent agenth[];
tb_config m_cfg;

function new(string name="dest_agent_top",uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);

if(!uvm_config_db #(tb_config) :: get(this,"","tb_config",m_cfg))
	`uvm_fatal(get_type_name(),"getting is failed")

if(m_cfg.has_dagent)
begin
	agenth = new[m_cfg.no_of_destinations];

foreach(agenth[i])
begin
	agenth[i] = dest_agent :: type_id :: create($sformatf("agenth[%0d]",i),this);
	uvm_config_db #(dest_config) :: set(this,$sformatf("agenth[%0d]*",i),"dest_config",m_cfg.d_cfg[i]);
end
end
endfunction

endclass

