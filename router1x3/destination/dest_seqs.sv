class dest_base_seq extends uvm_sequence #(dest_xtn);

`uvm_object_utils(dest_base_seq)
tb_config m_cfg;
function new(string name= "dest_base_seq");
super.new(name);
endfunction

task body();
if(!uvm_config_db #(tb_config) :: get(null,get_full_name(),"tb_config",m_cfg))
	`uvm_fatal(get_type_name(),"getting is failed")

endtask

endclass

class short_delay_seq extends dest_base_seq;
`uvm_object_utils(short_delay_seq)

function new(string name="short_delay_seq");
super.new(name);
endfunction


task body();
super.body();

repeat(m_cfg.no_of_transactions)
begin
	req= dest_xtn :: type_id :: create("req");
	start_item(req);
	assert(req.randomize() with {delay <20;});
	finish_item(req);
end

endtask
endclass
	

class high_delay_seq extends dest_base_seq;
`uvm_object_utils(high_delay_seq)

function new(string name="high_delay_seq");
super.new(name);
endfunction


task body();
super.body();

repeat(m_cfg.no_of_transactions)
begin
	req= dest_xtn :: type_id :: create("req");
	start_item(req);
	assert(req.randomize() with {delay >30;});
	finish_item(req);
end

endtask
endclass
	
