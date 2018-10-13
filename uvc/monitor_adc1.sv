class monitor_adc1 extends uvm_monitor;
		`uvm_component_utils (monitor_adc1)

//virtual dut_intf vif0;
//virtual dut_intf vif1;
//virtual dut_intf vif2;
virtual dut_intf vif3;
	
messages my_message;
uvm_analysis_port # (messages) mon_port ;

		function new (string name ="monitor_adc1",uvm_component parent);
		       super.new(name,parent);
	       endfunction

	       function void build_phase (uvm_phase phase);
			super.build_phase (phase);
			mon_port =new("mon_port",this);
	       endfunction

	       function void connect_phase (uvm_phase phase);
			uvm_config_db #(virtual dut_intf) :: get (null,"","interface3",this.vif3);
	       endfunction


	       task run_phase (uvm_phase phase);
			my_message = messages::type_id::create ("my_message");

		       forever
			begin
			@(posedge vif3.clock);
			
			wait (vif3.PREADY)
			@(posedge vif3.clock);

			my_message.PRDATA =  vif3.PRDATA;
		//	my_message.print();
			mon_port.write (my_message);	
			end		

	       endtask 
	       
       endclass 
