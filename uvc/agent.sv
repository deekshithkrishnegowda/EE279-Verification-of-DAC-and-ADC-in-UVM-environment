class agent extends uvm_agent;
	`uvm_component_utils(agent)

	driver my_driver;
	sequencer my_sequencer;
	bfm my_bfm;
	monitor_dac0 my_monitor_dac0;
	monitor_adc0 my_monitor_adc0;
	monitor_dac1 my_monitor_dac1;
	monitor_adc1 my_monitor_adc1;

	function new (string name ="agent",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		my_driver = driver::type_id::create("my_driver",this);
		my_sequencer = sequencer::type_id::create("my_sequencer",this);
		my_bfm = bfm :: type_id::create ("my_bfm",this);
		my_monitor_dac0 = monitor_dac0 ::type_id ::create ("my_monitor_dac0",this);
		my_monitor_adc0 = monitor_adc0 ::type_id ::create ("my_monitor_adc0",this);
		my_monitor_dac1 = monitor_dac1 ::type_id ::create ("my_monitor_dac1",this);
		my_monitor_adc1 = monitor_adc1 ::type_id ::create ("my_monitor_adc1",this);

	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		my_driver.seq_item_port.connect(my_sequencer.seq_item_export);
		my_driver.analysis_port.connect(my_bfm.analysis_fifo.analysis_export);
		my_bfm.analysis_port_pready.connect (my_driver.analysis_fifo_pready.analysis_export);
	endfunction

endclass
