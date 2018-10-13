class scoreboard extends uvm_scoreboard;
		`uvm_component_utils(scoreboard)

messages my_message1;
messages my_message2;

uvm_tlm_analysis_fifo #(messages) mon_fifo_dac;
uvm_tlm_analysis_fifo #(messages) mon_fifo_adc;

logic [31:0] queue_PRDATA [$:100];
logic [31:0] queue_PWDATA [$:100];

		function new (string name ="scoreboard",uvm_component parent);
			super.new(name,parent);
		endfunction

		function void build_phase (uvm_phase phase);
			super.build_phase (phase);
			mon_fifo_dac = new ("mon_fifo_dac",this);
			mon_fifo_adc = new("mon_fifo_adc",this);
		endfunction

		task run_phase (uvm_phase phase);
		fork
			forever
			begin
			my_message1 = messages :: type_id::create ("my_message1");
			mon_fifo_adc.get (my_message1);
			queue_PRDATA.push_back (my_message1.PRDATA);	
			end
		
			forever
			begin
			my_message2 = messages :: type_id::create ("my_message2");	
			mon_fifo_dac.get (my_message2);
			queue_PWDATA.push_back (my_message2.PWDATA);
			end
	
		join
		endtask

			function void check_phase(uvm_phase phase);

			$display ("\n \n IF PADDR > 32'h ffff_0000 -> SLAVE1 ,DAC0 & ADC0"); 
			$display (" \n IF PADDR < 32'h ffff_0000 -> SLAVE2 ,DAC1 & ADC1 \n ");	
				foreach(queue_PWDATA[i])
					$display ("PRDATA from ADC %h",queue_PRDATA[i+1]);
					//queue_PRDATA.pop_front;
					$display ("========================");
				foreach (queue_PWDATA[i])
					$display ("PWDATA from DAC  %h",queue_PWDATA[i]);
					//queue_PRDATA.pop_front;
			endfunction

		      
			
		
	endclass
