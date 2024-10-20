class source_monitor extends uvm_monitor;

`uvm_component_utils (source_monitor)

uvm_analysis_port #(source_xtn) monitor_port;

source_config m_cfg;
virtual source_if.MON_MP vif;
source_xtn xtn;

function new(string name="source_monitor",uvm_component parent);
super.new(name,parent);
monitor_port = new("monitor_port",this);
endfunction

function void build_phase(uvm_phase phase);
 if(!uvm_config_db #(source_config) :: get(this,"","source_config",m_cfg))
		`uvm_fatal(get_type_name(),"getting is failed")

endfunction

function void connect_phase(uvm_phase phase);
vif = m_cfg.vif;
endfunction

task run_phase(uvm_phase phase);
phase.raise_objection(this);
xtn = source_xtn :: type_id :: create("xtn");
repeat(m_cfg.no_of_transactions)
monitor();
phase.drop_objection(this);
endtask



task monitor();
wait(vif.mon_cb.busy==0);
while(vif.mon_cb.pkt_valid !==1)
@(vif.mon_cb);

xtn.header = vif.mon_cb.data_in;
xtn.payload = new[xtn.header[7:2]];
@(vif.mon_cb);

foreach(xtn.payload[i])
	begin
		while(vif.mon_cb.busy !==0)
			@(vif.mon_cb);
		xtn.payload[i] = vif.mon_cb.data_in;
		@(vif.mon_cb);
	end

xtn.parity = vif.mon_cb.data_in;

repeat(2) @(vif.mon_cb);

xtn.error = vif.mon_cb.error;

monitor_port.write(xtn);
//`uvm_info(get_type_name(),$sformatf("from source monitor %s",xtn.sprint()),UVM_LOW)

repeat(20) @(vif.mon_cb);

endtask


endclass
