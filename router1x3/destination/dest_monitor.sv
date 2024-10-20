class dest_monitor extends uvm_monitor;

`uvm_component_utils (dest_monitor)

uvm_analysis_port #(dest_xtn) monitor_port;
dest_xtn xtn;
dest_config m_cfg;
virtual dest_if.MON_MP vif;


function new(string name="dest_monitor",uvm_component parent);
super.new(name,parent);
monitor_port = new("monitor_port",this);
endfunction

function void build_phase(uvm_phase phase);
 if(!uvm_config_db #(dest_config) :: get(this,"","dest_config",m_cfg))
		`uvm_fatal(get_type_name(),"getting is failed")
xtn = dest_xtn :: type_id :: create("xtn");
endfunction

function void connect_phase(uvm_phase phase);
vif = m_cfg.vif;
endfunction

task run_phase(uvm_phase phase);
repeat(m_cfg.no_of_transactions)
begin
	monitor();
//	`uvm_info(get_type_name(),$sformatf("from destination monitor %s " , xtn.sprint()),UVM_LOW)
	monitor_port.write(xtn);
end

endtask

task monitor();
wait(vif.mon_cb.valid_out==1);

while(vif.mon_cb.read_enb !==1)
	@(vif.mon_cb);
@(vif.mon_cb);

xtn.header = vif.mon_cb.data_out;
xtn.payload = new[xtn.header[7:2]];

@(vif.mon_cb);

foreach(xtn.payload[i])
	begin
		xtn.payload[i] = vif.mon_cb.data_out;
		@(vif.mon_cb);
	end

xtn.parity = vif.mon_cb.data_out;

repeat(10) @(vif.mon_cb);

endtask



endclass
