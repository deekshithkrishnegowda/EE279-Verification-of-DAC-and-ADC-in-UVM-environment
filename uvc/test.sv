class test extends uvm_test;
	`uvm_component_utils(test)

	environment my_environment;
	//test_sequence my_sequence; 
	sample_sequence sample_seq;

	function new (string name = "test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		//uvm_top.print_topology();
		my_environment = environment::type_id::create ("my_environment",this);
	endfunction


	task run_phase(uvm_phase phase);
	//my_sequence =test_sequence::type_id::create ("my_sequence");
	sample_seq = sample_sequence :: type_id :: create ("sample_seq");
		begin
		phase.raise_objection(this,"sequnce starting");	
	//	my_sequence.start(my_environment.my_agent.my_sequencer);
	
		sample_seq.start (my_environment.my_virtual_sequencer);

		#1000;
		phase.drop_objection(this,"sequence done");
		end
	endtask
	
endclass
