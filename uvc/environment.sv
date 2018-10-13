class environment extends uvm_env;
	`uvm_component_utils(environment)
	
	agent my_agent;
	scoreboard my_scoreboard;
	virtual_sequencer my_virtual_sequencer;

	function new (string name = "environment",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		my_scoreboard = scoreboard ::type_id::create ("my_scoreboard",this);
		my_agent = agent::type_id::create ("my_agent",this);
		my_virtual_sequencer = virtual_sequencer :: type_id :: create ("my_virtual_sequencer",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		my_virtual_sequencer.my_sequencer = my_agent.my_sequencer;
	
		my_agent.my_monitor_dac0.mon_port.connect(my_scoreboard.mon_fifo_dac.analysis_export);
		my_agent.my_monitor_adc0.mon_port.connect(my_scoreboard.mon_fifo_adc.analysis_export );

		my_agent.my_monitor_dac1.mon_port.connect(my_scoreboard.mon_fifo_dac.analysis_export);
		my_agent.my_monitor_adc1.mon_port.connect(my_scoreboard.mon_fifo_adc.analysis_export );

	endfunction

endclass
