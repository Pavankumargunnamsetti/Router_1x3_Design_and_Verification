class dest_driver extends uvm_driver #(dest_xtn);

`uvm_component_utils (dest_driver)

dest_config m_cfg;
virtual dest_if.DRV_MP vif;


function new(string name="dest_driver",uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
 if(!uvm_config_db #(dest_config) :: get(this,"","dest_config",m_cfg))
		`uvm_fatal(get_type_name(),"getting is failed")

endfunction

function void connect_phase(uvm_phase phase);
vif = m_cfg.vif;
endfunction

//task run_phase(uvm_phase phase);
task run_phase(uvm_phase phase);
repeat(m_cfg.no_of_transactions)
	begin
		seq_item_port.get_next_item(req);
	//	`uvm_info(get_type_name(),$sformatf("from destination driver %s",req.sprint()),UVM_LOW)
		send_to_dut(req);
		
		seq_item_port.item_done();

	end
endtask

task send_to_dut(dest_xtn xtn);
while(vif.drv_cb.valid_out !==1)
	@(vif.drv_cb);

repeat(xtn.delay)
	@(vif.drv_cb);

vif.drv_cb.read_enb <= 1;

while(vif.drv_cb.valid_out !==0)
@(vif.drv_cb);

//repeat(xtn.delay)
//	@(vif.drv_cb);

vif.drv_cb.read_enb <=0;



endtask

endclass
