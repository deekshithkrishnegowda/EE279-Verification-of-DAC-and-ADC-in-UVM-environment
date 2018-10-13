class bfm extends uvm_driver # (messages);
	`uvm_component_utils (bfm)


uvm_tlm_analysis_fifo # (messages) analysis_fifo;

uvm_analysis_port #(messages) bfm_port_sb ;

uvm_analysis_port # (message_pready) analysis_port_pready;

messages my_message;
message_pready my_message_pready;
//dummy dummy_one ;
//
virtual dut_intf vif0;
virtual dut_intf vif1;
virtual dut_intf vif2;
virtual dut_intf vif3;

real voltage_one [$:100];
real voltage_two [$:100];
//logic [31:0] queue_PWDATA_bfm[$:100];

	function new (string name = "bfm", uvm_component parent);
		super.new (name,parent);
	endfunction

	function void  build_phase (uvm_phase phase);
		super.build_phase(phase);
		analysis_fifo =new ("analysis_fifo",this);
		analysis_port_pready =new ("analysis_fifo_pready",this);
		bfm_port_sb = new("bfm_port_sb",this);
	endfunction

	function void connect_phase (uvm_phase phase);
		uvm_config_db #(virtual dut_intf) :: get (null,"","interface0",this.vif0);
		uvm_config_db #(virtual dut_intf) :: get (null,"","interface1",this.vif1);
		uvm_config_db #(virtual dut_intf) :: get (null,"","interface2",this.vif2);
		uvm_config_db #(virtual dut_intf) :: get (null,"","interface3",this.vif3);
	
	
	endfunction



	task run_phase (uvm_phase phase);

	//	@(posedge vif0.clock);vif0.PRESET <= 1;
	//	@(posedge vif0.clock);vif0.PRESET <= 0;

//	@(posedge vif0.clock);
	
		forever
			begin
				my_message= messages::type_id::create("my_message");
				my_message_pready = message_pready :: type_id :: create ("my_message_pready");
		//		dummy_one= dummy::type_id::create ("dummy_one");						
				analysis_fifo.get (my_message);
			if (my_message.PADDR >= 32'hffff_0000)
				drive_to_slave1 (my_message);
			else
				drive_to_slave2 (my_message);
			//	my_message.print();
				analysis_port_pready.write(my_message_pready);
	
			end	
	endtask


	task drive_to_slave1(messages my_message);

	@(posedge vif0.clock);
//	$display (" PADDR > 32' hffff_0000");
//	$display (" SLAVE1 is ACTIVE , DAC0 and ADC0 ");
	
		if (my_message.PWRITE) //DAC : slave1
			begin
			 	vif0.PRESET <= #1 my_message.PRESET;
				if (my_message.PRESET)
					begin
						@(posedge vif0.clock);
		        			vif0.PWDATA <= #1 32'b0;	
		        			vif0.PWRITE <= #1 0;
		        			vif0.PENABLE <= #1 0;
		        			vif0.PSEL <= #1 0;
		        			my_message_pready.SEND_NEW_DATA  =  1;
						voltage_one.delete();
		 			end
		
				else 
					begin
					//IDLE
						@(posedge vif0.clock);
						my_message_pready.SEND_NEW_DATA = 0;
						vif0.PWDATA <= #1 my_message.PWDATA;
						vif0.PRESET <= #1 my_message.PRESET;
						vif0.PSEL <= #1 my_message.PSEL;
						vif0.PWRITE <= #1 my_message.PWRITE;
					//	$display ("sending to slave 1 %h",my_message.PWDATA);
						
						
					//SETUP
						@(posedge vif0.clock);
						if (vif0.PSEL)
						begin
							vif0.PENABLE <= #1 1;
				
					//ACCESS PHASE
							@(posedge vif0.clock);
							wait (vif0.PREADY && vif0.PENABLE)
							my_message_pready.PREADY = #1 vif0.PREADY;
							vif0.PENABLE <= #1 0;	
							
						//	bfm_port_sb.write(my_message);
						//	$display ("PWDATA %h",vif0.PWDATA);
						//	$display ("PWDATA sending %h",my_message.PWDATA);
							
							if (vif0.PREADY)
							voltage_one.push_back (vif0.vout);
						//	queue_PWDATA_bfm.push_back (vif0.PWDATA);															
						end
					end
				end
		else   //ADC : slave 1
		begin
			
			vif1.PRESET <= #1 my_message.PRESET;
			if (my_message.PRESET)
				begin

				@(posedge vif0.clock);
		        	vif1.PRDATA <= #1 32'b0;	
		        	vif1.PWRITE <= #1 0;
		        	vif1.PENABLE <= #1 0;
		        	vif1.PSEL <= #1 0;
		        	my_message_pready.SEND_NEW_DATA  =  1;
		 		
				end
		
			else 
				begin
				//IDLE
					@(posedge vif1.clock);
					my_message_pready.SEND_NEW_DATA = 0;
				//	vif1.PRDATA <= #1 my_message.PWDATA;
					vif1.PRESET <= #1 my_message.PRESET;
					vif1.PSEL <= #1 my_message.PSEL;
					vif1.PWRITE <= #1 my_message.PWRITE;
				//SETUP
					@(posedge vif1.clock);
					if (vif1.PSEL)
					begin
						vif1.PENABLE <= #1 1;
				
				//ACCESS PHASE
						@(posedge vif1.clock);
						wait (vif1.PREADY && vif1.PENABLE)
						my_message_pready.PREADY = #1 vif1.PREADY;
						vif1.PENABLE <= #1 0;		
			
						
						if (vif1.PREADY)
							vif1.vin <= voltage_one.pop_front;
							
							
						//	$display ("receiving from slave 1 %h",vif1.PRDATA); 			
					end
				end
	
			end
			
	endtask : drive_to_slave1





	task drive_to_slave2(messages my_message);

	@(posedge vif2.clock);
//	$display (" PADDR < 32' hffff_0000");
//	$display (" SLAVE2 is ACTIVE , DAC1 and ADC1 ");

		if (my_message.PWRITE) //DAC : slave2
			begin
			 	vif2.PRESET <= #1 my_message.PRESET;
				if (my_message.PRESET)
					begin
						@(posedge vif2.clock);
		        			vif2.PWDATA <= #1 32'b0;	
		        			vif2.PWRITE <= #1 0;
		        			vif2.PENABLE <= #1 0;
		        			vif2.PSEL <= #1 0;
		        			my_message_pready.SEND_NEW_DATA  =  1;
						voltage_two.delete();
		 			end
		
				else 
					begin
					//IDLE
						@(posedge vif2.clock);
						my_message_pready.SEND_NEW_DATA = 0;
						vif2.PWDATA <= #1 my_message.PWDATA;
						vif2.PRESET <= #1 my_message.PRESET;
						vif2.PSEL <= #1 my_message.PSEL;
						vif2.PWRITE <= #1 my_message.PWRITE;
					//	$display ("sending to slave 2 %h",my_message.PWDATA);
					//SETUP
						@(posedge vif2.clock);
						if (vif2.PSEL)
						begin
							vif2.PENABLE <= #1 1;
				
					//ACCESS PHASE
							@(posedge vif2.clock);
							wait (vif2.PREADY && vif2.PENABLE)
							my_message_pready.PREADY = #1 vif2.PREADY;
							vif2.PENABLE <= #1 0;		
						
							if (vif2.PREADY)
							voltage_two.push_back (vif2.vout);
										
						end
					end
				end
		else   //ADC : slave 2
		begin
			
			vif3.PRESET <= #1 my_message.PRESET;
			if (my_message.PRESET)
				begin

				@(posedge vif3.clock);
		        	vif3.PRDATA <= #1 32'b0;	
		        	vif3.PWRITE <= #1 0;
		        	vif3.PENABLE <= #1 0;
		        	vif3.PSEL <= #1 0;
		        	my_message_pready.SEND_NEW_DATA  =  1;
		 		
				end
		
			else 
				begin
				//IDLE
					@(posedge vif3.clock);
					my_message_pready.SEND_NEW_DATA = 0;
				//	vif1.PRDATA <= #1 my_message.PWDATA;
					vif3.PRESET <= #1 my_message.PRESET;
					vif3.PSEL <= #1 my_message.PSEL;
					vif3.PWRITE <= #1 my_message.PWRITE;
				//SETUP
					@(posedge vif3.clock);
					if (vif3.PSEL)
					begin
						vif3.PENABLE <= #1 1;
				
				//ACCESS PHASE
						@(posedge vif3.clock);
						wait (vif3.PREADY && vif3.PENABLE)
						my_message_pready.PREADY = #1 vif3.PREADY;
						vif3.PENABLE <= #1 0;		
			
						
						if (vif3.PREADY)
							vif3.vin <= voltage_two.pop_front;
					//		$display ("receiving from slave 2 %h",vif3.PRDATA); 			
					end
				end
	
			end
			
	endtask : drive_to_slave2

	
endclass
