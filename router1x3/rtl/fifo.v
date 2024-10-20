
module fifo(clock,resetn,soft_reset,write_enb,
            read_enb,lfd_state,data_in,full,empty,data_out);

input clock,resetn,soft_reset,write_enb,read_enb,lfd_state;
input[7:0]data_in;
output reg [7:0]data_out;
output full,empty;

reg lfd_temp;
reg[8:0]fifo[15:0];
reg [4:0]wr_pt,rd_pt;
reg  [6:0] temp_count;
integer i,j;

//assign full =((wr_pt == 16)&&(rd_pt == 0));
assign full = (wr_pt == {~rd_pt[4],rd_pt[3:0]});//00000, 10000// 01111, 11111, 01010, 11010
assign empty = (wr_pt == rd_pt);

 
always@(posedge clock)
begin
 
  if(lfd_state)
		lfd_temp <= lfd_state;
	else
		lfd_temp <= 1'b0;
end


//write logic
always@(posedge clock)
begin
	if(!resetn) //active low reset
		 begin
			wr_pt <= 0;
			for(i=0;i<16;i=i+1)
				fifo[i] <= 0;
		 end
	else if(soft_reset)
		 begin
			wr_pt <= 0;
			for(j=0;j<16;j=j+1)
				fifo[j] <= 0;
		 end
	else if(write_enb && !full)
		begin
			fifo[wr_pt[3:0]] <= {lfd_temp, data_in};//1,  10001010 = 110001010
			wr_pt <= wr_pt+1'b1;
		end
	/*else if(full || temp_count == 0) //down count all bytes are written including parity byte
		wr_pt <= 0;*/
		
	else
		wr_pt <= wr_pt;
end

//counter logic
// counter is used to down count 
always@(posedge clock)
begin
	if(!resetn) 
		  temp_count <= 0;
	else if(soft_reset)
		  temp_count <= 0;
	           
	else if(read_enb && !empty)//header byte presence
			begin
				if(fifo[rd_pt[3:0]][8]==1'b1) // fifo[rd_pt] = 101001010
					temp_count <= fifo[rd_pt[3:0]][7:2]+1;/// payload length + parity = 16
				else 
				temp_count <= temp_count - 1'b1;//down counting from payload1 to 16 t0 parity
			end
	else if(temp_count == 0)
			data_out <= 8'bz;
	else
			temp_count <= temp_count;
end


//read logic
always@(posedge clock)
 begin
   if(!resetn)
         begin
         data_out <= 8'd0;
         rd_pt <= 4'd0;
         end
	else if(soft_reset)
         begin
           data_out <= 8'dz;
           rd_pt <= 4'd0;
         end
		
   else if(read_enb && !empty)
         begin
           data_out <= fifo[rd_pt[3:0]][7:0]; //fifo[7:0]
           rd_pt <= rd_pt + 1'b1;
         end
			
	/*else if(read_enb && empty)
		begin
        data_out <= 8'bz;
		  rd_pt <= 4'd0;
		 end*/
		 
/*	else if(temp_count == 0)
		begin
			data_out <= 8'bz;
			/*rd_pt <= 4'd0;
		end*/
		
	else
		
			/*data_out <= data_out;*/
			rd_pt <= rd_pt;
end
 
endmodule 

                                   

