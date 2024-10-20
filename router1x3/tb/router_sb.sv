class router_sb extends uvm_scoreboard;
`uvm_component_utils (router_sb)

uvm_tlm_analysis_fifo #(source_xtn) fifo_srh;
uvm_tlm_analysis_fifo #(dest_xtn) fifo_drh[];

tb_config m_cfg;
source_xtn s_xtn;
dest_xtn d_xtn;

int recieved_data_count;
int mismatched_data_count;
int verified_data_count;
 
function new(string name="router_sb",uvm_component parent);
super.new(name,parent);
s_cov = new;
d_cov = new;
endfunction


function void build_phase(uvm_phase phase);

if(!uvm_config_db #(tb_config) :: get(this,"","tb_config",m_cfg))
	`uvm_fatal(get_type_name(),"getting is failed")
fifo_drh = new[m_cfg.no_of_destinations];

foreach(fifo_drh[i])
	fifo_drh[i] = new($sformatf("fifo_drh[%0d]",i),this);

fifo_srh = new("fifo_srh",this);

endfunction

covergroup s_cov;
	PAYLOAD_LENGTH: coverpoint s_xtn.header[7:2]{
					bins small_payload={[1:20]};
					bins medium_payload={[21:40]};
					bins large_payload = {[41:63]};
						}
	ADDRESS : coverpoint s_xtn.header[1:0]{
					bins address[]={0,1,2};
					illegal_bins ILLB={3};
						}
	ERROR : coverpoint s_xtn.error;
endgroup

covergroup d_cov;
	
PAYLOAD_LENGTH: coverpoint d_xtn.header[7:2]{
					bins small_payload={[1:20]};
					bins medium_payload={[21:40]};
					bins large_payload = {[41:63]};
						}
ADDRESS : coverpoint d_xtn.header[1:0]{
					bins address[]={0,1,2};
					illegal_bins ILLB={3};
						}
endgroup


task run_phase(uvm_phase phase);
forever
		begin
		fifo_srh.get(s_xtn);
		s_cov.sample();
		recieved_data_count ++;
		fifo_drh[s_xtn.header[1:0]].get(d_xtn);
		d_cov.sample();
		compare_data(s_xtn,d_xtn);
		end
endtask


function void compare_data(source_xtn s_xtn, dest_xtn d_xtn);
`uvm_info(get_type_name(),$sformatf("\n__________________________________________________________________________________________\n\nsource_monitor object %s \n destination monitor object %s \n\n ______________________________________________________",s_xtn.sprint(),d_xtn.sprint()),UVM_LOW)
if(s_xtn.header !== d_xtn.header)
	begin
		`uvm_info(get_type_name(),"header mismatched",UVM_LOW)
		mismatched_data_count++;
		return;
	end

if(s_xtn.payload == d_xtn.payload)
	`uvm_info(get_type_name(),"payload matched",UVM_LOW)
else
	`uvm_info(get_type_name(),"payload mismatched",UVM_LOW)

foreach(s_xtn.payload[i])
if(s_xtn.payload[i] !== d_xtn.payload[i])
	begin
		`uvm_info(get_type_name(),$sformatf("payload[%0d] is mismatched",i),UVM_LOW)
		mismatched_data_count++;
		return;
	end


if(s_xtn.parity !== d_xtn.parity)
	begin

		`uvm_info(get_type_name(),"parity mismatched",UVM_LOW)
		mismatched_data_count++;
		return;
	end

`uvm_info(get_type_name(), "source and destination data matched",UVM_LOW)
verified_data_count ++;
endfunction


function void report_phase(uvm_phase phase);
`uvm_info(get_type_name(),"scoreboard report_phase",UVM_LOW)
`uvm_info(get_type_name(),$sformatf("\n _____________________________________________________________________________\n\n recieved_data_count - %0d \n verified_data_count - %0d \n mismatched_data_count -%0d \n ______________________________________________________________________________",recieved_data_count,verified_data_count,mismatched_data_count),UVM_LOW)

endfunction
endclass
