interface dest_if(input bit clock);

logic read_enb;
logic valid_out;
logic [7:0] data_out;


clocking drv_cb @(posedge clock);
default input #1 output #1;

output read_enb;
input valid_out;
endclocking


clocking mon_cb @(posedge clock);
default input #1 output #1;
input read_enb,valid_out,data_out;
endclocking

modport DRV_MP(clocking drv_cb);
modport MON_MP(clocking mon_cb);
endinterface
