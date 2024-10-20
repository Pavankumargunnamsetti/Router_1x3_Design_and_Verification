class source_base_seq extends uvm_sequence #(source_xtn);

`uvm_object_utils (source_base_seq)
tb_config m_cfg;

function new(string name="source_base_seq");
super.new(name);
endfunction

task body();

if(!uvm_config_db #(tb_config) :: get(null, get_full_name(),"tb_config",m_cfg))
	`uvm_fatal(get_type_name(),"getting is failed ")

endtask

endclass


class small_payload_seq extends source_base_seq;

`uvm_object_utils (small_payload_seq)

function new(string name="small_payload_seq");
super.new(name);
endfunction

task body();
super.body();

repeat(m_cfg.no_of_transactions)
begin
	req = source_xtn :: type_id :: create("req");
	start_item(req);
	assert(req.randomize() with {header[7:2] inside {[1:17]}; header[1:0]== m_cfg.address;});
 	finish_item(req);
end
endtask
endclass





class mid_payload_seq extends source_base_seq;

`uvm_object_utils (mid_payload_seq)

function new(string name="mid_payload_seq");
super.new(name);
endfunction

task body();
super.body();

repeat(m_cfg.no_of_transactions)
begin
	req = source_xtn :: type_id :: create("req");
	start_item(req);
	assert(req.randomize() with {header[7:2] inside {[17:40]}; header[1:0]== m_cfg.address;});
 	finish_item(req);
end
endtask
endclass





class high_payload_seq extends source_base_seq;

`uvm_object_utils (high_payload_seq)

function new(string name="high_payload_seq");
super.new(name);
endfunction

task body();
super.body();

repeat(m_cfg.no_of_transactions)
begin
	req = source_xtn :: type_id :: create("req");
	start_item(req);
	assert(req.randomize() with {header[7:2]==63 /*inside {[41:63]}*/; header[1:0]== m_cfg.address;});
 	finish_item(req);
end
endtask
endclass
