interface source_if(input bit clock);


logic [7:0] data_in;

logic pkt_valid;
logic resetn;
logic busy;
logic error;

clocking drv_cb @(posedge clock);
default input #1 output #1;
output data_in,pkt_valid,resetn;
input busy;
endclocking


clocking mon_cb @(posedge clock);
default input #1 output #1;
input data_in, pkt_valid,resetn, busy, error;
endclocking


modport DRV_MP(clocking drv_cb);
modport MON_MP(clocking mon_cb);
endinterface
