
module register(clock,resetn,pkt_valid,
					 data_in,fifo_full,rst_int_reg,
					 detect_add,ld_state,laf_state,
					 full_state,lfd_state,parity_done,
					 low_pkt_valid,err,dout);

//Input/Output Port Declaration
input clock,resetn,pkt_valid;
input [7:0] data_in;
input fifo_full,detect_add,ld_state,laf_state,
 full_state,lfd_state,rst_int_reg;
output reg parity_done,low_pkt_valid,err;
output reg [7:0] dout;

//Internal Register declaration
 reg [7:0] hold_header_byte,fifo_full_state_byte,internal_parity,packet_parity_byte;

//Parity_done
always@(posedge clock)
begin
if(!resetn)
		parity_done<=1'b0;
else if(detect_add)
		parity_done <= 1'b0;
else if(ld_state && !fifo_full && !pkt_valid)
		parity_done <= 1'b1;
else if(laf_state && low_pkt_valid && !parity_done)
		parity_done<=1'b1; 
end

//________________ ________________________________________________________________
//low_packet_valid
always@(posedge clock)
	begin
		if(!resetn)
			low_pkt_valid <= 1'b0;
		else
			begin
				if(rst_int_reg)
					low_pkt_valid <= 1'b0;
				else if(ld_state && !pkt_valid)
					low_pkt_valid <= 1'b1;
			end
	end
//________________________________________________________________________________
//error
always@(posedge clock)
	begin
	 if(!resetn)
		err<=1'b0;
	 else
		 begin
			if(parity_done)
				begin
					if(internal_parity != packet_parity_byte)
						err<=1'b1;
					else
						err<=1'b0;
				end
		 end
	end
//________________________________________________________________________________
//dout
always@(posedge clock)
begin
	if(!resetn)
		dout <= 1'b0;
	else if (detect_add && pkt_valid && data_in[1:0]!=3)
		dout<=dout;
	else if(lfd_state)
		dout <= hold_header_byte;
	else if(ld_state && !fifo_full)
		dout <= data_in;
	else if(ld_state && fifo_full)
		dout <= dout;
	else if(laf_state)
		dout <= fifo_full_state_byte;
	else
		dout <= dout;
 end
 

//Hold_Header_Byte
always@(posedge clock)
begin
	if(!resetn)
		hold_header_byte <= 8'b0;
	else if(detect_add && pkt_valid && data_in[1:0]!=3)
		hold_header_byte <= data_in;
	else
		hold_header_byte <= hold_header_byte;
end

//________________________________________________________________________________
//FIFO_Full_State_Byte
always@(posedge clock)
	begin
		if(!resetn)
			fifo_full_state_byte <= 8'b0;
		else if(ld_state && fifo_full)
			fifo_full_state_byte <= data_in;
		else 
			fifo_full_state_byte <= fifo_full_state_byte;
	end
//________________________________________________________________________________
//Internal_Parity_Byte
always@(posedge clock)
	begin
		if(!resetn)
			internal_parity <= 8'b0;
		else if(detect_add)
			internal_parity <= 8'b0;
		else if(lfd_state)
			internal_parity <= internal_parity ^ hold_header_byte;
		else if(pkt_valid && ld_state && ~full_state)
			internal_parity <= internal_parity ^ data_in;
		else
			internal_parity<=internal_parity;
	end
//________________________________________________________________________________
//Packet_Parity_Byte
always@(posedge clock)
	begin
		if(!resetn)
			packet_parity_byte <= 8'b0;
		else if(detect_add)
			packet_parity_byte <= 8'd0;
		else if(ld_state && ~pkt_valid)
			packet_parity_byte <= data_in;
		else
			packet_parity_byte <= packet_parity_byte;
	end
endmodule

