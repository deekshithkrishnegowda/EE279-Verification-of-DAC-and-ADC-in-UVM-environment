class test_sequence extends uvm_sequence #(messages);
	`uvm_object_utils(test_sequence)

	messages my_message;

	function new(string name="my_sequence");
		super.new(name);
	endfunction

	task body ();
			begin
			my_message = messages::type_id::create("my_message");
				begin
					start_item(my_message);
					assert (my_message.randomize() with {PRESET==1;PWRITE==1;PADDR < 32'h ffff_0000;})
					finish_item(my_message);
				end
				
				//do not drive continous PWRITE=1 for more than
				//100 times. The queue in BFM can only take
				//100 values

				repeat (15) 
				begin
					start_item(my_message);
					assert (my_message.randomize() with {PSEL==1;PWRITE==1;PRESET==0;PADDR < 32'h ffff_0000;})
					finish_item(my_message);

				end
					begin
					start_item(my_message);
					my_message.PWDATA.rand_mode(0);
					assert (my_message.randomize() with {PRESET==1;PWRITE==0; PADDR < 32'h ffff_0000;})
					finish_item(my_message);
				end
				// drive 1 more PWRITE = 0 than PWRITE=1. this
				// is done to make sure entire data is out of
				// DUT;

				repeat (16)
				begin
					start_item(my_message);
					assert (my_message.randomize() with {PSEL==1;PWRITE==0;PRESET==0; PADDR < 32'h ffff_0000;})
					finish_item(my_message);

				end


			end
	endtask
	
endclass

