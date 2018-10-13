interface dut_intf (input bit clock);

	logic PWRITE,PENABLE,PRESET;
	logic  PSEL;
	logic [31:0] PWDATA,PADDR;

	logic [31:0] PRDATA;
	logic PREADY,PSLVERR;
	real vout,vin;

	
/*	clocking bfm_cb (@ posedge clock);
	default input #1 output #1 ;
	
		input PREADY;

		output PWDATA;
		output PSEL;
		output PWRITE;
		output PENABLE;
		output PRESET;
		
	endclocking

	clocking mon_cb (@ posedge clock);
	default input #1 output #1;
		
		input PRDATA;
		input PSLVERR;
		input PREADY;

	endclocking

modport BFM_MP ( clocking bfm_cb );
modport MON_MP ( clocking mon_cb );
*/

endinterface
