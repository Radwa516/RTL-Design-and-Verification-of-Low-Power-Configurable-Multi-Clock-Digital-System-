
`timescale 1ns/1ps
`include "interface.sv"
import UART_Package::*;
import uvm_pkg::*;

module A_TOP ();
bit UART_CLK;
bit REF_CLK;


INTF_UART U_intf (UART_CLK, REF_CLK);

System_Top # (.DATA_WID_S(DATA_WIDTH_TB),.Addr_Width_S(ADDR_WIDTH_TB), .NUM_STAGES_S(NUM_STAGES_TB)) DUT 
(
.UART_CLK(UART_CLK),
.REF_CLK(REF_CLK),
.U_intf(U_intf)
);

//////////////////////Interal Tap Points////////////////////
assign U_intf.TX_CLK 	= U0_UART.TX_CLK;
assign U_intf.Busy   	= U0_UART.Busy;
assign U_intf.Div_Ratio = U0_Reg_File.REG2;
assign U_intf.P_Data  	= U0_UART.P_DATA;
assign U_intf.RX_Valid  = U0_UART.DATA_VALID;

initial 
	begin
		initialization();

		uvm_config_db#(virtual INTF_UART)::set(null,"uvm_test_top","my_vif",U_intf);
		run_test("Test");
	end   

////////////////////initialization of the inputs///////////////////
task initialization;
     begin
		U_intf.RST = 'b0;
        U_intf.RX_IN = 'b1;
     end
endtask

////////////////////UART Clock Generation/////////////////////////
	initial 
		begin
			UART_CLK = 0;
			forever 
				begin
					#(UART_CLK_PER/2) UART_CLK = ~UART_CLK;
				end
		end

////////////////////REF Clock Generation//////////////////////////
	initial 
		begin
			REF_CLK = 0;
			forever 
				begin
					#(REF_CLK_PER/2) REF_CLK = ~REF_CLK;
				end
		end

endmodule
