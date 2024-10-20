class source_xtn extends uvm_sequence_item;
`uvm_object_utils (source_xtn)

rand bit [7:0] header;
rand bit [7:0] payload[];
rand bit [7:0] parity;
bit error;

function new(string name="source_xtn");
super.new(name);
endfunction

function void post_randomize();
parity = header;

foreach(payload[i])
	parity = parity ^ payload[i];
endfunction 

constraint head{header[1:0] != 3; header[7:2] != 0;}
constraint pay_len{payload.size == header[7:2];}


function void do_print(uvm_printer printer);

printer.print_field("header",this.header,8,UVM_BIN);
foreach(payload[i])
	printer.print_field($sformatf("payload[%0d]",i),this.payload[i],8,UVM_BIN);
printer.print_field("parity",this.parity,8,UVM_BIN);
printer.print_field("error",this.error,1,UVM_DEC);

endfunction

endclass
