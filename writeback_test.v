`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   06:56:41 03/03/2014
// Design Name:   writeback
// Module Name:   C:/Users/pravinkumar/Documents/GitHub/AsyncARM/writeback_test.v
// Project Name:  AsyncARM
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: writeback
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module writeback_test;
	
	reg reset;

	wire [31:0] data_wrg;
	wire [3:0] addr_wrg;
	wire trigger_wrg;
	wire [31:0]cpsr_wrg;
	
	wire trigger_aw;
	wire [31:0] data1_aw;
	wire [31:0] data2_aw;
	wire [31:0] cpsr_aw;
	wire ready_aw;
	wire w_aw;
	wire [31:0]srcDst_aw;
	
	wire [31:0] data1_da;
	wire [31:0] data2_da;
	wire [31:0] data3_da;
	wire [31:0] data4_da;
	wire [3:0] type_da;
	wire ready_da;
	wire trigger_da;
	wire [31:0]srcDst_da;
	
	wire ready_drg;
	wire [31:0] data_drg;
	wire [3:0] addr_drg;
	wire trigger_drg;
	
	wire ready_fi;
	wire [31:0] data_fi;
	wire trigger_fi;
	
	wire trigger_id;
	wire ready_id;
	wire [31:0] data_id;
	
	wire [31:0]data_rf;
	wire trigger_rf;
	wire ready_rf;
	wire [31:0]addr_rf;
	
	wire [31:0]pcW_frg;
	wire [31:0]pcR_frg;
	
	wire [31:0]cpsr_irg;
	


	// Instantiate the Unit Under Test (UUT)
	writeback uut (
		.reset(reset), 
		.dataIn1(data1_aw), 
		.dataIn2(data2_aw), 
		.cpsrIn(cpsr_aw), 
		.srcDstIn(srcDst_aw), 
		.readyIn(ready_aw), 
		.wIn(w_aw), 
		.dataOut(data_wrg), 
		.addrOut(addr_wrg), 
		.cpsrOut(cpsr_wrg), 
		.triggerOut(trigger_aw), 
		.triggerOutRB(trigger_wrg)
	);
	
	////////////////////////////////////////////////////
	
	alu alu1 (
		.reset(reset), 
		.dataIn1(data1_da), 
		.dataIn2(data2_da), 
		.dataIn3(data3_da), 
		.dataIn4(data4_da), 
		.typeIn(type_da), 
		.triggerIn(trigger_aw), 
		.readyIn(ready_da), 
		.dataOut1(data1_aw), 
		.dataOut2(data2_aw), 
		.cpsrOut(cpsr_aw), 
		.triggerOut(trigger_da), 
		.readyOut(ready_aw), 
		.w(w_aw), 
		.srcDstIn(srcDst_da), 
		.srcDstOut(srcDst_aw)
	);
	
	///////////////////////////////////////////////////////////
	
	decode decode1 (
		.reset(reset), 
		.dataIn(data_id), 
		.readyIn(ready_id), 
		.triggerIn(trigger_da), 
		.dataOut1(data1_da), 
		.dataOut2(data2_da), 
		.dataOut3(data3_da), 
		.dataOut4(data4_da), 
		.typeOut(type_da), 
		.readyOut(ready_da), 
		.triggerOut(trigger_id), 
		.readyInRB(ready_drg), 
		.dataInRB(data_drg), 
		.addrRB(addr_drg), 
		.triggerOutRB(trigger_drg), 
		.srcDstOut(srcDst_da)
	);
	
	
	///////////////////////////////////////////////////////
	
	issuer issue1 (
		.reset(reset),
		.readyIn(ready_fi), 
		.dataIn(data_fi), 
		.triggerOut(trigger_fi), 
		.triggerIn(trigger_id), 
		.readyOut(ready_id), 
		.dataOut(data_id), 
		.cpsr(cpsr_irg)
	);
	
	//////////////////////////////////////
	
	fetch fetch1 (
		.reset(reset),
		.triggerIn(trigger_fi), 
		.dataOut(data_fi), 
		.readyOut(ready_fi), 
		.dataIn(data_rf), 
		.triggerOut(trigger_rf), 
		.readyIn(ready_rf), 
		.addrOut(addr_rf), 
		.pcIn(pcR_frg), 
		.pcOut(pcW_frg)
	);
	//////////////////////////////////////
	
	rom rom1(
	 .addr(addr_rf),
	 .data(data_rf),
	 .triggerIn(trigger_rf),
	 .readyOut(ready_rf)
	 );
	
	//////////////////////////////////////
	
	regbank regb (
		.triggerInr(trigger_drg),
		.triggerInw(trigger_wrg),
		.dataIn(data_wrg),
		.addrr(addr_drg),
		.addrw(addr_wrg),
		.readyOut(ready_drg),
		.dataOut(data_drg),
		.pcIn(pcW_frg),
		.pcOut(pcR_frg),
		.cpsrOut(cpsr_irg),
		.cpsrIn(cpsr_wrg)
	);
	
	///////////////////////////////////////

	initial begin
		// Initialize Inputs
		reset =0;

		// Wait 100 ns for global reset to finish
		#100;
		
		reset =1;
		
		#500 $finish;
        
		// Add stimulus here

	end
      
endmodule

