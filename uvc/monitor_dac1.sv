class monitor_dac1 extends uvm_monitor;
		`uvm_component_utils (monitor_dac1)

//virtual dut_intf vif0;
//virtual dut_intf vif1;
virtual dut_intf vif2;
//virtual dut_intf vif3;
	
messages my_message;

uvm_analysis_port # (messages) mon_port ;

		function new (string name ="monitor_dac1",uvm_component parent);
		       super.new(name,parent);
	       endfunction

	       function void build_phase (uvm_phase phase);
			super.build_phase (phase);
			mon_port =new("mon_port",this);
	       endfunction

	       function void connect_phase (uvm_phase phase);
			uvm_config_db #(virtual dut_intf) :: get (null,"","interface2",this.vif2);
	       endfunction


	       task run_phase (uvm_phase phase);
			my_message = messages::type_id::create ("my_message");

		       forever
			begin
			@(posedge vif2.clock);
			
			wait (vif2.PREADY)
			@(posedge vif2.clock);

			my_message.PWDATA =  vif2.PWDATA;
		//	my_message.print();
			mon_port.write (my_message);	
			end		

	       endtask 
	       
       endclass 
