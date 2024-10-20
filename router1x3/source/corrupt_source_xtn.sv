class corrupt_source_xtn extends source_xtn ;
`uvm_object_utils (corrupt_source_xtn)


function new(string name="corrupt_source_xtn");
 super.new(name);
endfunction

function void post_randomize();
 parity =  header;

foreach(payload[i])
	 parity =  parity ~^ payload[i];
endfunction 

endclass

