class base_test extends uvm_test;

`uvm_component_utils (base_test);

env envh;
tb_config m_cfg;
//===================================CONFIG PARAMETERS==============================

bit [1:0] address;
bit has_sb = 1;
bit has_virtual_sequencer = 1;
bit has_dagent = 1;
bit has_sagent = 1;
int no_of_destinations = 3;
int no_of_transactions = 1;

source_config s_cfg;
dest_config d_cfg[];

//================================================================================


function new(string name="base_test",uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
m_cfg = tb_config :: type_id :: create("m_cfg");

if(has_sagent)
	begin
		s_cfg = source_config :: type_id :: create("s_cfg");
		s_cfg.is_active = UVM_ACTIVE;
		s_cfg.no_of_transactions = no_of_transactions;
		if(!uvm_config_db #(virtual source_if) :: get(this,"","sif",s_cfg.vif))
			`uvm_fatal(get_type_name(),"getting interface is failed")
		m_cfg.s_cfg = s_cfg;
	end

if(has_dagent)
	begin
		d_cfg = new[no_of_destinations];
		m_cfg.d_cfg = new[no_of_destinations];
	foreach(d_cfg[i])
		begin
			d_cfg[i] = dest_config :: type_id :: create($sformatf("d_cfg[%0d]",i));
			d_cfg[i].is_active = UVM_ACTIVE;
			d_cfg[i].no_of_transactions = no_of_transactions;
			if(!uvm_config_db #(virtual dest_if) :: get(this,"",$sformatf("dif_%0d",i),d_cfg[i].vif))
				`uvm_fatal(get_type_name(),$sformatf("getting interface is failed for d_cfg[%0d]",i))
			m_cfg.d_cfg[i] = d_cfg[i];
		end
	end

m_cfg.address = address;
m_cfg.has_sb = has_sb;
m_cfg.has_virtual_sequencer = has_virtual_sequencer;
m_cfg.has_sagent = has_sagent;
m_cfg.has_dagent = has_dagent;
m_cfg.no_of_destinations = no_of_destinations;
m_cfg.no_of_transactions = no_of_transactions;


uvm_config_db #(tb_config) :: set(this,"*","tb_config",m_cfg);
envh = env:: type_id::create("envh",this);
endfunction 

endclass


//==================================================
class small_payload_test extends base_test;
`uvm_component_utils(small_payload_test)
small_v_seq v_seq;
function new(string name="small_payload_test",uvm_component parent);
super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
address=0;
super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
phase.raise_objection(this);
v_seq = small_v_seq :: type_id :: create("v_seq");
v_seq.start(envh.v_sequencer);
phase.drop_objection(this);
endtask
endclass

//=========================================================

class mid_payload_test extends base_test;
`uvm_component_utils(mid_payload_test)

mid_v_seq v_seqh;


function new(string name="mid_payload_test",uvm_component parent);
super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
address = 1;
super.build_phase(phase);
v_seqh = mid_v_seq :: type_id :: create("seqh");

endfunction

task run_phase(uvm_phase phase);
phase.raise_objection(this);
v_seqh.start(envh.v_sequencer);
phase.drop_objection(this);
endtask
endclass
//================================================================
class high_payload_test extends base_test;
`uvm_component_utils(high_payload_test)

high_v_seq seqh;

function new(string name="high_payload_test",uvm_component parent);
super.new(name,parent);
endfunction 

function void build_phase(uvm_phase phase);
address=2;
factory.set_type_override_by_type(source_xtn::get_type(),corrupt_source_xtn::get_type(),1);
super.build_phase(phase);
seqh = high_v_seq :: type_id :: create("seqh");

endfunction

task run_phase(uvm_phase phase);
phase.raise_objection(this);
seqh.start(envh.v_sequencer);
phase.drop_objection(this);
endtask
endclass



//----------------------------------------------
