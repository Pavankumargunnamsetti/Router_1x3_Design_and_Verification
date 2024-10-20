class dest_xtn extends uvm_sequence_item;
`uvm_object_utils (dest_xtn)
bit [7:0] header;
bit [7:0] payload[];
bit [7:0] parity;

rand bit[5:0] delay;

constraint delay_range{delay inside {[1:63]};}

function new(string name="dest_xtn");
super.new(name);
endfunction


function void do_print(uvm_printer printer);

printer.print_field("header",this.header,8,UVM_BIN);
foreach(payload[i])
	printer.print_field($sformatf("payload[%0d]",i),this.payload[i],8,UVM_BIN);
printer.print_field("parity",this.parity,8,UVM_BIN);
printer.print_field("delay",this.delay,6,UVM_DEC);

endfunction

endclass
