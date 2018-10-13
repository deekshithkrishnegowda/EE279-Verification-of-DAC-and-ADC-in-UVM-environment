class driver extends uvm_driver #(messages);
	`uvm_component_utils (driver)

messages my_message;
message_pready my_message_pready;

uvm_analysis_port #(messages) analysis_port;
uvm_tlm_analysis_fifo # (message_pready) analysis_fifo_pready;
//uvm_analysis_port #(messages) drv_port;

	function new (string name ="driver",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		uvm_top.print_topology();
		analysis_port =new("analysis_port",this);
		analysis_fifo_pready =new ("analysis_fifo_pready",this);
	//	drv_port =new ("drv_port",this);
	endfunction

	function void connect_phase (uvm_phase phase);
		super.connect_phase(phase);
	endfunction

	task run_phase (uvm_phase phase);
		//super.run_phase;
		forever	
			begin
				seq_item_port.get_next_item(my_message);
				drive_item(my_message);		
				analysis_fifo_pready.get(my_message_pready);
				wait (my_message_pready.PREADY || my_message_pready.SEND_NEW_DATA)
				//$display (get_full_name(),"got PREADY");
							seq_item_port.item_done();		
			end
	endtask
	
	task drive_item(messages my_message);
//		analysis_fifo.get(my_pready);
		analysis_port.write (my_message);
//		if(my_message.PWRITE)
//        	drv_port.write (my_message);
	//	$display ("DATA_TO_SB %h ",my_message.PWDATA);

		endtask

endclass
		

