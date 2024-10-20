
module router_top(input clock,resetn,read_enb_0,read_enb_1,read_enb_2,pkt_valid,
						 input [7:0]data_in,
						 output [7:0]data_out_0,data_out_1,data_out_2,
						 output valid_out_0,valid_out_1,valid_out_2,error,busy);

//Internal_Wires_Declaration
/*wire [2:0]empty;
wire [2:0]soft_reset;

wire [2:0]full;*/
wire [7:0]dout;
wire [2:0]write_enb;

/*//FSM_MODULE_INSTANTIATION
 fsm_control FSM(.clock(clock),.resetn(resetn),.pkt_valid(pkt_valid),.data_in(data_in[1:0]),
.parity_done(parity_done),.low_packet_valid(low_pkt_valid),.fifo_full(fifo_full),
.fifo_empty_0(empty[0]),.fifo_empty_1(empty[1]),.fifo_empty_2(empty[2]),
.soft_reset_0(soft_reset[0]),.soft_reset_1(soft_reset[1]),.soft_reset_2(soft_reset[2]),
.write_enb_reg(write_enb_reg),.detect_add(detect_add),.ld_state(ld_state),
.laf_state(laf_state),.lfd_state(lfd_state),.full_state(full_state),.rst_int_reg(rst_int_reg),
.busy(busy));*/

fsm_control FSM(clock,resetn,pkt_valid,data_in[1:0],parity_done,low_packet_valid,
						 fifo_full,empty_0,empty_1,empty_2,
						 soft_reset_0,soft_reset_1,soft_reset_2,
						 write_enb_reg,detect_add,ld_state,laf_state,
						 lfd_state,full_state,rst_int_reg,busy);

/*//SYNCHRONIZER_MODULE_INSTANTIATION
 router_synchronizer SYNC(.clock(clock),.resetn(resetn),.detect_add(detect_add),
.write_enb_reg(write_enb_reg),.write_enb(write_enb),.data_in(data_in),
.empty_0(empty[0]),.empty_1(empty[1]),.empty_2(empty[2]),.read_enb_0(read_enb_0),
.read_enb_1(read_enb_1),.read_enb_2(read_enb_2),.full_0(full[0]),.full_1(full[1]),
.full_2(full[2]),.fifo_full(fifo_full),.vld_out_0(valid_out_0),.vld_out_1(valid_out_1),
.vld_out_2(valid_out_2),.soft_reset_0(soft_reset[0]),.soft_reset_1(soft_reset[1]),
.soft_reset_2(soft_reset[2]));*/

router_synchronizer SYNC(clock,resetn,detect_add,write_enb_reg,
									write_enb,data_in,empty_0,empty_1,empty_2,
									read_enb_0,read_enb_1,read_enb_2,
									full_0,full_1,full_2,fifo_full,
									valid_out_0,valid_out_1,valid_out_2,
									soft_reset_0,soft_reset_1,soft_reset_2);

/*//REGISTER_MODULE_INSTANTIATION
 register REG(.clock(clock),.resetn(resetn),.pkt_valid(pkt_valid),.data_in(data_in),
.fifo_full(fifo_full),.rst_int_reg(rst_int_reg),.detect_add(detect_add),.ld_state(ld_state),
.laf_state(laf_state),.full_state(full_state),.lfd_state(lfd_state),.parity_done(parity_done),
.low_pkt_valid(low_pkt_valid),.err(error),.dout(dout));*/


register REG(clock,resetn,pkt_valid,
					 data_in,fifo_full,rst_int_reg,
					 detect_add,ld_state,laf_state,
					 full_state,lfd_state,parity_done,
					 low_packet_valid,error,dout);

/*//FIFO_MODULE_INSTANTIATION
//FIFO_0
 fifo FIFO_0(.clock(clock),.resetn(resetn),.soft_reset(soft_reset[0]),
 .write_enb(write_enb[0]),.read_enb(read_enb_0),.data_in(dout),.lfd_state(lfd_state),
 .data_out(data_out_0),.full(full[0]),.empty(empty[0]));*/
 
fifo FIFO0(clock,resetn,soft_reset_0,write_enb[0],
            read_enb_0,lfd_state,dout,full_0,empty_0,data_out_0);

/*//FIFO_1
 fifo FIFO_1(.clock(clock),.resetn(resetn),.soft_reset(soft_reset[1]),
 .write_enb(write_enb[1]),.read_enb(read_enb_1),.lfd_state(lfd_state),
 .data_in(dout),.data_out(data_out_1),.full(full[1]),.empty(empty[1]));*/
fifo FIFO1(clock,resetn,soft_reset_1,write_enb[1],
            read_enb_1,lfd_state,dout,full_1,empty_1,data_out_1);
/*//FIFO_2
 fifo FIFO_2(.clock(clock),.resetn(resetn),.soft_reset(soft_reset[2]),
 .write_enb(write_enb[2]),.read_enb(read_enb_2),.data_in(dout),.lfd_state(lfd_state),
 .data_out(data_out_2),.full(full[2]),.empty(empty[2]));*/
fifo FIFO2(clock,resetn,soft_reset_2,write_enb[2],
            read_enb_2,lfd_state,dout,full_2,empty_2,data_out_2);
endmodule

