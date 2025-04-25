///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////Radwa_sequence_item//////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Radwa_sequence_item extends uvm_sequence_item;

	`uvm_object_utils (Radwa_sequence_item)
	
///////////////////////////////////inputs of the design//////////////////////
	logic RX_IN;
	logic RST;
	logic TX_OUT;
	
///////////////////////////////////randomize the frames to send it //////////////////////
	randc  logic [(DATA_WIDTH_TB-1):0] Frame0;
	randc  logic [(DATA_WIDTH_TB-1):0] ALU_FUNC;
	randc  logic [(ADDR_WIDTH_TB-1):0] Write_Addr; //write address
	randc  logic [(DATA_WIDTH_TB-1):0] Write_data;
	randc  logic [(ADDR_WIDTH_TB-1):0] Read_Addr;
	randc  logic [(DATA_WIDTH_TB-1):0] OP_A;
	randc  logic [(DATA_WIDTH_TB-1):0] OP_B;
	randc  logic [(DATA_WIDTH_TB-1):0] Config;
	randc  logic [(ADDR_WIDTH_TB-1):0] Address;
	
//////////////////////////////////some internal signals to check properties
	logic [(DATA_WIDTH_TB-1):0] Div_Ratio;
	logic		Busy;
	logic [(DATA_WIDTH_TB-1):0]	P_Data;
	
	
	function new(string name = "my_sequence_item");
		super.new(name);
	endfunction
	
	
	constraint const0 	{Frame0 inside {8'hAA, 8'hBB, 8'hCC, 8'hDD};}
	constraint const_ALU_FUNC {ALU_FUNC inside {[8'b0000:8'b1110]};}
	constraint const1_AA {Write_Addr inside {['d04:'d15]};}
	constraint const2_AA {Write_data inside {['h00:'hFF]};}
	constraint const1_BB {Read_Addr inside {['d00:'d15]};}
	constraint const_Address {Address inside {['h00:'h03]};}
	constraint Configrations {Config inside {'h83, 'h80, 'h41, 'h43, 'h40, 'h21, 'h23, 'h20};}
	constraint const_OP_A {OP_A inside {['h00:'hFF]};}
	constraint const_OP_B {OP_B inside {['h00:'hFF]};}
	
endclass

