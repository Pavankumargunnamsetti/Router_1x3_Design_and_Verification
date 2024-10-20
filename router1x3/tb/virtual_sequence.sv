class virtual_sequence_base extends uvm_sequence #(uvm_sequence_item);

`uvm_object_utils(virtual_sequence_base)

virtual_sequencer v_seqr;

source_sequencer s_seqr;
dest_sequencer d_seqr[];
tb_config m_cfg;


function new(string name="virtual_sequence_base");
super.new(name);
endfunction

task body();
if(!$cast(v_seqr,m_sequencer))
	`uvm_fatal(get_type_name(),"casting is failed")


if(!uvm_config_db #(tb_config) :: get(null,get_full_name(),"tb_config",m_cfg))
	`uvm_fatal(get_type_name(),"getting is failed")

d_seqr = new[m_cfg.no_of_destinations];

s_seqr = v_seqr.s_seqrh;

foreach(d_seqr[i])
	d_seqr[i] = v_seqr.d_seqrh[i];

endtask
endclass
//=======================================

class small_v_seq extends virtual_sequence_base;

`uvm_object_utils(small_v_seq)

small_payload_seq s_seqh;
short_delay_seq d_seqh;
function new(string name="small_v_seq");
super.new(name);
endfunction

task body();
super.body();

s_seqh = small_payload_seq :: type_id :: create("s_seqh");
d_seqh = short_delay_seq :: type_id :: create("d_seqh");

fork
s_seqh.start(s_seqr);
d_seqh.start(d_seqr[m_cfg.address]);
join

endtask

endclass

//=======================================

class mid_v_seq extends virtual_sequence_base;

`uvm_object_utils(mid_v_seq)

mid_payload_seq s_seqh;
short_delay_seq d_seqh;
function new(string name="mid_v_seq");
super.new(name);
endfunction

task body();
super.body();

s_seqh = mid_payload_seq :: type_id :: create("s_seqh");
d_seqh = short_delay_seq :: type_id :: create("d_seqh");

fork
s_seqh.start(s_seqr);
d_seqh.start(d_seqr[m_cfg.address]);
join

endtask

endclass

//=======================================

class high_v_seq extends virtual_sequence_base;

`uvm_object_utils(high_v_seq)

high_payload_seq s_seqh;
short_delay_seq d_seqh;
function new(string name="high_v_seq");
super.new(name);
endfunction

task body();
super.body();

s_seqh = high_payload_seq :: type_id :: create("s_seqh");
d_seqh = short_delay_seq :: type_id :: create("d_seqh");

fork
s_seqh.start(s_seqr);
d_seqh.start(d_seqr[m_cfg.address]);
join

endtask

endclass






