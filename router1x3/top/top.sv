module top();

import uvm_pkg::*;
import router_pkg::*;

`include "uvm_macros.svh"

bit clock;

always #5 clock = ~clock;

source_if sif(clock);
dest_if dif0(clock);
dest_if dif1(clock);
dest_if dif2(clock);


router_top DUV(.clock(clock),
		.resetn(sif.resetn),
		.read_enb_0(dif0.read_enb),
		.read_enb_1(dif1.read_enb),
		.read_enb_2(dif2.read_enb),
		.pkt_valid(sif.pkt_valid),
		.data_in(sif.data_in),
		.data_out_0(dif0.data_out),
		.data_out_1(dif1.data_out),
		.data_out_2(dif2.data_out),
		.valid_out_0(dif0.valid_out),
		.valid_out_1(dif1.valid_out),
		.valid_out_2(dif2.valid_out),
		.error(sif.error),
		.busy(sif.busy));




initial 
begin
	
	
	`ifdef VCS
	$fsdbDumpvars(0, top);
	`endif
	
	uvm_config_db #(virtual source_if) :: set(null,"*","sif",sif);
	uvm_config_db #(virtual dest_if) :: set(null,"*","dif_0",dif0);
	uvm_config_db #(virtual dest_if) :: set(null,"*","dif_1",dif1);
	uvm_config_db #(virtual dest_if) :: set(null,"*","dif_2",dif2);
	
	uvm_top.enable_print_topology = 1;
	run_test();
end





property pkt_valid;
@(posedge clock) $rose(sif.pkt_valid) |=> sif.busy;
endproperty

PKT_VALID : cover property (pkt_valid);


property busy;
@(posedge clock) sif.busy |-> $stable(sif.data_in);
endproperty

BUSY: cover property (busy);

/*
property pkt_valid_valid_out;
@(posedge clock) $rose(sif.pkt_valid) |-> if(sif.data_in[1:0]==0)
						##3 dif0.valid_out;
					else if(sif.data_in[1:0]==1)
						##3 dif1.valid_out;
					else if(sif.data_in[1:0]==2)
						##3 dif2.valid_out;
endproperty

VALID_OUT : cover property (pkt_valid_valid_out);
*/


property pkt_valid0;
	@(posedge clock) $rose(sif.pkt_valid) && (sif.data_in[1:0]==0) |-> ##3 dif0.valid_out;
endproperty
PKT_VALID_VALID_OUT_0 : cover property (pkt_valid0);

property pkt_valid1;
	@(posedge clock) $rose(sif.pkt_valid) && (sif.data_in[1:0]==1) |-> ##3 dif1.valid_out;
endproperty
PKT_VALID_VALID_OUT_1 : cover property (pkt_valid1);

property pkt_valid2;
	@(posedge clock) $rose(sif.pkt_valid) && (sif.data_in[1:0]==2) |-> ##3 dif2.valid_out;
endproperty
PKT_VALID_VALID_OUT_2 : cover property (pkt_valid2);




property valid_out_0;
	@(posedge clock) $rose(dif0.valid_out) |=> ##[0:30] dif0.read_enb;
endproperty

VALID_OUT_0 : cover property (valid_out_0);

property valid_out_1;
	@(posedge clock) $rose(dif1.valid_out) |=> ##[0:30] dif1.read_enb;
endproperty

VALID_OUT_1 : cover property (valid_out_1);


property valid_out_2;
	@(posedge clock) $rose(dif2.valid_out) |=> ##[0:30] dif2.read_enb;
endproperty

VALID_OUT_2 : cover property (valid_out_2);


property read_enb_0;
@(posedge clock) $fell(dif0.valid_out) |=> $fell(dif0.read_enb);
endproperty

READ_ENB_0: cover property (read_enb_0);


property read_enb_1;
@(posedge clock) $fell(dif1.valid_out) |=> $fell(dif1.read_enb);
endproperty

READ_ENB_1: cover property (read_enb_1);


property read_enb_2;
@(posedge clock) $fell(dif2.valid_out) |=> $fell(dif2.read_enb);
endproperty

READ_ENB_2: cover property (read_enb_2);



endmodule


	
