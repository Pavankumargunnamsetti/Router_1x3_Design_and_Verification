class source_driver extends uvm_driver #(source_xtn);

`uvm_component_utils (source_driver)

source_config m_cfg;
virtual source_if.DRV_MP vif;

function new(string name="source_driver",uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
 if(!uvm_config_db #(source_config) :: get(this,"","source_config",m_cfg))
		`uvm_fatal(get_type_name(),"getting is failed")

endfunction

function void connect_phase(uvm_phase phase);
vif = m_cfg.vif;
endfunction

task run_phase(uvm_phase phase);
repeat(m_cfg.no_of_transactions)
	begin
		//	@(vif.drv_cb);
	seq_item_port.get_next_item(req);
//`uvm_info(get_type_name(),$sformatf("from source driver %s",req.sprint()),UVM_LOW)
	send_to_dut(req);
//`uvm_info(get_type_name(),$sformatf("from source driver %s",req.sprint()),UVM_LOW)

	seq_item_port.item_done();
	end
endtask

task send_to_dut(source_xtn xtn);
	@(vif.drv_cb);
	vif.drv_cb.resetn <= 0;
	@(vif.drv_cb);
	vif.drv_cb.resetn <= 1;

while(vif.drv_cb.busy !==0)
	@(vif.drv_cb);
vif.drv_cb.pkt_valid <= 1;
vif.drv_cb.data_in <= xtn.header;
@(vif.drv_cb);

foreach(xtn.payload[i])
	begin
		while(vif.drv_cb.busy !== 0)
			@(vif.drv_cb);
	vif.drv_cb.data_in <= xtn.payload[i];
	@(vif.drv_cb);
	end
while(vif.drv_cb.busy !== 0)
	@(vif.drv_cb);
vif.drv_cb.data_in <= xtn.parity;
vif.drv_cb.pkt_valid <= 0;


repeat(50) @(vif.drv_cb);


endtask

endclass
