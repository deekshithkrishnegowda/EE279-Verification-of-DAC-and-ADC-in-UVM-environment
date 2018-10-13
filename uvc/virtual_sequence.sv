class virtual_sequence extends uvm_sequence # (uvm_sequence_item);
	`uvm_object_utils(virtual_sequence)

virtual_sequencer my_virtual_sequencer;
sequencer my_sequencer;

	function new (string name ="virtual_sequence");
		super.new (name);
	endfunction

	task body ();
		if (! $cast (my_virtual_sequencer,m_sequencer))
		begin
			`uvm_error(get_type_name(),"failed to cast")
		end
		my_sequencer = my_virtual_sequencer.my_sequencer;
	endtask : body

endclass



class sample_sequence extends virtual_sequence;

	`uvm_object_utils(sample_sequence)
	test_sequence sample_seq;


	task body ();
		super.body();
		sample_seq =  test_sequence ::type_id::create("sample_seq");
		sample_seq.start (my_sequencer);
	endtask

endclass
