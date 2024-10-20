
module router_synchronizer(clock,resetn,detect_add,write_enb_reg,
									write_enb,data_in,empty_0,empty_1,empty_2,
									read_enb_0,read_enb_1,read_enb_2,
									full_0,full_1,full_2,fifo_full,
									vld_out_0,vld_out_1,vld_out_2,
									soft_reset_0,soft_reset_1,soft_reset_2);

input clock,resetn,detect_add,write_enb_reg,empty_0,empty_1,empty_2,read_enb_0,read_enb_1,read_enb_2,full_0,full_1,full_2;
input [7:0]data_in;
output reg [2:0]write_enb;
output reg fifo_full,soft_reset_0,soft_reset_1,soft_reset_2;
output wire vld_out_0,vld_out_1,vld_out_2;

reg [1:0]temp_addr;
reg [4:0]count_0,count_1,count_2;

always@(posedge clock)
begin
if(!resetn)
temp_addr <= 2'd0;
else if(detect_add)
temp_addr <= data_in;
else
temp_addr <= temp_addr;
end

always@(*)
begin
	if(write_enb_reg)
		begin
			case(temp_addr)
				2'b00: write_enb = 3'b001;
				2'b01: write_enb = 3'b010;
				2'b10: write_enb = 3'b100;
				default: write_enb = 3'b000;
			endcase
		end
	else
	write_enb = 3'b000;
end

always@(*)
	begin
		case(temp_addr)
			2'b00: fifo_full = full_0; 
			2'b01: fifo_full = full_1; 
			2'b10: fifo_full = full_2;
			default fifo_full = 0;
		endcase
	end

assign vld_out_0 = ~empty_0;
assign vld_out_1 = ~empty_1;
assign vld_out_2 = ~empty_2;

//soft_reset counter Block
//COUNTER 0
always@(posedge clock)
begin
 if(!resetn)
	 begin
	 count_0 <= 5'd0;
	 soft_reset_0 <= 1'b0;
	 end
 else if(vld_out_0)
	 begin
		if(!read_enb_0)
			 begin
				if(count_0 == 5'd29)//30 CLOCK CYCLES
					 begin
						soft_reset_0 <= 1'b1;
						count_0 <= 5'd0;
					end
				else
					 begin
						count_0 <= count_0 + 1'b1;
						soft_reset_0 <= 1'b0;
					 end
				end
		else 
			count_0 <= 5'd0;
	end
else 
	count_0 <= 5'd0;
end

//COUNTER 1
always@(posedge clock)
begin
 if(!resetn)
	 begin
	 count_1 <= 5'd0;
	 soft_reset_1 <= 1'b0;
	 end
 else if(vld_out_1)
	 begin
		if(!read_enb_1)
			 begin
				if(count_1 == 5'd29)
					 begin
						soft_reset_1 <= 1'b1;
						count_1 <= 5'd0;
					end
				else
					 begin
						count_1 <= count_1+1'b1;
						soft_reset_1 <= 1'b0;
					 end
				end
		else 
			count_1 <= 5'd0;
	end
else 
	count_1 <= 5'd0;
end


//COUNTER 2
always@(posedge clock)
begin
 if(!resetn)
	 begin
	 count_2 <= 5'd0;
	 soft_reset_2<=1'b0;
	 end
 else if(vld_out_2)
	 begin
		if(!read_enb_2)
			 begin
				if(count_2 == 5'd29)
					 begin
						soft_reset_2 <= 1'b1;
						count_2 <= 5'd0;
					end
				else
					 begin
						count_2 <= count_2+1'b1;
						soft_reset_2 <= 1'b0;
					 end
				end
		else 
			count_2 <= 5'd0;
	end
else 
	count_2 <= 5'd0;
end

endmodule


