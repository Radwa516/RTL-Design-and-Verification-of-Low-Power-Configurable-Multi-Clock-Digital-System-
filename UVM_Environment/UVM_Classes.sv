`include "uvm_macros.svh"
`timescale 1ns/1ps  

package UART_Package;

import uvm_pkg::*;

parameter DATA_WIDTH_TB  = 8;
parameter NUM_STAGES_TB  = 2;
parameter ADDR_WIDTH_TB  = 4;   
parameter REF_CLK_PER 	 = 20;         // 50 MHz
parameter UART_CLK_PER 	 = 271.267;   // 3.6864 MHz (115.2 * 32)
parameter WR_CMD  		 = 8'hAA;   
parameter RD_CMD  		 = 8'hBB;   
parameter ALU_WOP_CMD  	 = 8'hCC;   
parameter ALU_WNOP_CMD 	 = 8'hDD;   

//`include "Sequencer.sv"
`include "Sequence_item.sv"
`include "Driver.sv"
`include "Monitor.sv"
`include "Monitor_IN.sv"
`include "Sequence.sv"
`include "Agent_IN.sv"
`include "Agent.sv"
`include "Scoreboard.sv"
`include "Subscriber.sv"
`include "ENV.sv"
`include "Test.sv"

endpackage
