class messages extends uvm_sequence_item; 
`uvm_object_utils (messages)

	rand logic PWRITE;
	logic PENABLE;
	//logic PCLK;
	rand logic PSEL;
      	rand logic [31:0] PWDATA,PADDR;
	logic PSLVERR; 
	//logic PREADY;
	logic [31:0] PRDATA;
	rand logic PRESET;
	real vout;
 

 	function void do_print(uvm_printer printer);
		super.do_print(printer);
		printer.print_field("PADDR",this.PADDR,32,UVM_HEX);
		printer.print_field("PWDATA",this.PWDATA,32,UVM_HEX);
		printer.print_field("PRDATA",this.PRDATA,32,UVM_HEX);

		printer.print_field("PRESET",this.PRESET,1,UVM_DEC);
		printer.print_field("PWRITE",this.PWRITE,1,UVM_DEC);
		printer.print_field("PSEL",this.PSEL,1,UVM_DEC);
		printer.print_field("PRDATA",this.PRDATA,32,UVM_HEX);
		printer.print_field("PSLVERR",this.PSLVERR,1,UVM_DEC);
	endfunction

	function void do_copy(uvm_object rhs);
		messages rhs_;
 
		if(!$cast(rhs,rhs_))
			begin
			`uvm_warning("messages","messages:$cast failed");
			end
	
		super.do_copy(rhs);
		 PWDATA=rhs_.PWDATA;
		 PRDATA=rhs_.PRDATA;
		 PADDR = rhs_.PADDR;
		 PWRITE = rhs_.PWRITE;
		 PSEL = rhs_.PSEL;
		 PENABLE =rhs_.PENABLE;
	//	 PREADY= rhs_.PREADY;
		 PSLVERR=rhs_.PSLVERR;
		 PRESET=rhs_.PRESET;
	 endfunction

endclass


class message_pready extends uvm_sequence_item;
	`uvm_object_utils(message_pready)

logic PREADY;
logic SEND_NEW_DATA;
endclass


/*class dummy extends uvm_sequence_item;
	`uvm_object_utils(dummy)

	logic [31:0] PWDATA;

endclass*/
