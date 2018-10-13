import uvm_pkg ::*;
//import test_package ::*;
`include "../package/package.sv"
`include "dut_intf.sv"

`include "../proj/dac.sv"
`include "../proj/adc.sv"

module top();
bit clock;

dut_intf vif0( clock );
dut_intf vif1( clock );
dut_intf vif2( clock );
dut_intf vif3( clock );

dac DAC_DUT1 (.PCLK(clock),.PRESET(vif0.PRESET),
    .PSEL(vif0.PSEL),.PENABLE(vif0.PENABLE), .PWRITE(vif0.PWRITE),
    .PREADY(vif0.PREADY), .PWDATA(vif0.PWDATA), .PSLVERR(vif0.PSLVERR),
    .vout(vif0.vout));


adc ADC_DUT1 (.PCLK(clock),.PRESET(vif1.PRESET),
     .PSEL(vif1.PSEL),.PENABLE(vif1.PENABLE), .PWRITE(vif1.PWRITE),
    .PREADY(vif1.PREADY),.PRDATA(vif1.PRDATA), .PSLVERR(vif1.PSLVERR),
    .vin(vif1.vin));

dac DAC_DUT2 (.PCLK(clock),.PRESET(vif2.PRESET),
    .PSEL(vif2.PSEL),.PENABLE(vif2.PENABLE), .PWRITE(vif2.PWRITE),
    .PREADY(vif2.PREADY), .PWDATA(vif2.PWDATA), .PSLVERR(vif2.PSLVERR),
    .vout(vif2.vout));


adc ADC_DUT2 (.PCLK(clock),.PRESET(vif3.PRESET),
     .PSEL(vif3.PSEL),.PENABLE(vif3.PENABLE), .PWRITE(vif3.PWRITE),
    .PREADY(vif3.PREADY),.PRDATA(vif3.PRDATA), .PSLVERR(vif3.PSLVERR),
    .vin(vif3.vin));


initial
begin
	$dumpfile("DAC.vpd");
	$dumpvars (9,top);
end


always
begin
	#5;
	clock=1'b0;
	#5;
	clock =1'b1;
end

initial
begin

	uvm_config_db # (virtual dut_intf) :: set (null, "*" , "interface0" , vif0);
	uvm_config_db # (virtual dut_intf) :: set (null, "*" , "interface1" , vif1);
	uvm_config_db # (virtual dut_intf) :: set (null, "*" , "interface2" , vif2);
	uvm_config_db # (virtual dut_intf) :: set (null, "*" , "interface3" , vif3);
        
   // vif0.PRESET = 1;
    
    run_test("test");
    #100;
    $finish;
end

endmodule : top

