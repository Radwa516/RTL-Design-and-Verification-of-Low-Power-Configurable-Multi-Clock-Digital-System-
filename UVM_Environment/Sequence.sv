///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////sequencer///////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

class Sequencer extends uvm_sequencer #(Radwa_sequence_item);

      `uvm_component_utils (Sequencer)
///////////////////////////////////////////////new/////////////////////////////////////////////////////////////
  function new (string name, uvm_component parent);
     super.new(name, parent);
  endfunction


//////////////////////////////////////////build_phase//////////////////////////////////////////////////////////
    function void build_phase(uvm_phase phase);
       super.build_phase(phase);
       $display("build phase of sequencer");
    endfunction


///////////////////////////////////////////connect_phase///////////////////////////////////////////////////////
    function void connect_phase(uvm_phase phase);
       super.connect_phase(phase);
       $display("connect phase of sequencer");
    endfunction


//////////////////////////////////////////////run_phase////////////////////////////////////////////////////////
    task run_phase(uvm_phase phase);
       super.run_phase(phase);
       $display("run phase of sequencer");
    endtask
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
endclass

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////Sequence//////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//import UART_Package::*;
class Radwa_Sequence extends uvm_sequence #(Radwa_sequence_item);

	`uvm_object_utils (Radwa_Sequence)
	//virtual intf intf1;
	
	
	`uvm_declare_p_sequencer(Sequencer)
	uvm_event monitor_done_event;
  
	//////////////////tlm///////////////////////
	Radwa_sequence_item Rad_seq_item;
  
////////////////////////////////////////////////////new///////////////////////////////////////////////////////
	function new(string name = "my_sequence");
		super.new(name);
	endfunction
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

	task pre_start(); 
		super.pre_start();
		if (!uvm_config_db#(uvm_event)::get(p_sequencer, "", "monitor_done_event", monitor_done_event)) $display("Failed to get monitor_done_event in sequence");
	endtask


  
////////////////////////////////////////////build_phase///////////////////////////////////////////////////////
    task pre_body();
		Rad_seq_item = Radwa_sequence_item::type_id::create("Rad_seq_item");    
    endtask
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////run_test//////////////////////////////////////////////////////
    task body();
	logic 	Parity_type;
	logic   Parity_enable;
	
		for (int i = 0; i < 3; i++)
					begin
						start_item(Rad_seq_item);
						Rad_seq_item.RX_IN = 1'b1;
						Rad_seq_item.RST = 0;
						Rad_seq_item.ALU_FUNC = 'b0;
						Rad_seq_item.OP_A = 'b0;
						Rad_seq_item.OP_B = 'b0;
						Rad_seq_item.Write_Addr = 'h06;
						Rad_seq_item.Read_Addr = 'h02;
						Rad_seq_item.Write_data = 'd32;							
						finish_item(Rad_seq_item);
					end
					
						start_item(Rad_seq_item);
						Rad_seq_item.RX_IN = 1'b1;
						Rad_seq_item.RST = 1;
						Rad_seq_item.Config = 'h41;	
						finish_item(Rad_seq_item);
					
				$display("Config = %h", Rad_seq_item.Config);
				$display("par_en = %d, pat_type = %d, prescale = %d", Rad_seq_item.Config[0], Rad_seq_item.Config[1], Rad_seq_item.Config[7:2]);
				///////////////////////////////
				
		for (int t = 0; t < 24; t++) //24
			begin
				$display("///////////////////////////////////////////////////////////////////////////////////////////////");
				$display("Iteration = %d", t+1);
				$display("par_en = %d, pat_type = %d, prescale = %d", Rad_seq_item.Config[0], Rad_seq_item.Config[1], Rad_seq_item.Config[7:2]);
				$display("///////////////////////////////////////////////////////////////////////////////////////////////");
				
				/////////////////////////////////////////////////
				////////////// Sending Configration /////////////
				/////////////////////////////////////////////////

				//step 1 sending frame 0 as AA

						start_item(Rad_seq_item);
						Rad_seq_item.Frame0 = 'hAA;
						Rad_seq_item.Address = 'h02;
						Rad_seq_item.RX_IN = 1'b1;
						finish_item(Rad_seq_item);
						$display("Frame0 = %h", Rad_seq_item.Frame0);
						Sending_Frame(Rad_seq_item.Frame0);
						$display("Address = %h", Rad_seq_item.Address);
						Sending_Frame(Rad_seq_item.Address);
				
						Parity_enable = Rad_seq_item.Config[0];
						Parity_type = Rad_seq_item.Config[1];
				
						start_item(Rad_seq_item);
						assert(Rad_seq_item.randomize(Config));
						finish_item(Rad_seq_item);
				
						$display("Config = %h", Rad_seq_item.Config);
						$display("par_en = %d, pat_type = %d, prescale = %d", Rad_seq_item.Config[0], Rad_seq_item.Config[1], Rad_seq_item.Config[7:2]);
						Sending_Config(Parity_enable, Parity_type, Rad_seq_item.Config);
				

				/////////randomize frame zero (write or read or ALU)/////////////
				for (int op = 0; op < 41; op++) //32
					begin
						$display("///////////////////////////////////////////////");
						$display("Frame Number %d", op+1);
						$display("par_en = %d, pat_type = %d, prescale = %d", Rad_seq_item.Config[0], Rad_seq_item.Config[1], Rad_seq_item.Config[7:2]);
						$display("//////////////////////////////////////////////////");

						start_item(Rad_seq_item);
						assert(Rad_seq_item.randomize(Frame0));
						finish_item(Rad_seq_item);
				
						$display("Frame0 = %h", Rad_seq_item.Frame0);
						//////////// sending the frame //////////////////////////////
						Sending_Frame(Rad_seq_item.Frame0);
		
							////////////////randomize frame one ////////////////////////////
				
						case(Rad_seq_item.Frame0)
						'hAA : begin
								start_item(Rad_seq_item);	
								Rad_seq_item.RST = 1;
								assert(Rad_seq_item.randomize(Write_Addr));
								assert(Rad_seq_item.randomize(Write_data));							
								finish_item(Rad_seq_item);
							
								$display("Write_Addr = %h", Rad_seq_item.Write_Addr);
								Sending_Frame(Rad_seq_item.Write_Addr);
								$display("Write_data = %h", Rad_seq_item.Write_data);
								Sending_Frame(Rad_seq_item.Write_data);					

							end
							
						'hBB : begin
								start_item(Rad_seq_item);	
								Rad_seq_item.RST = 1;
								assert(Rad_seq_item.randomize(Read_Addr));
								finish_item(Rad_seq_item);
								
								$display("Read_Addr = %h", Rad_seq_item.Read_Addr);
								Sending_Frame(Rad_seq_item.Read_Addr);
									
								$display("Waiting for monitor");
								monitor_done_event.wait_on();
								monitor_done_event.reset();
								$display("monitor_done_event reset");
								
							end
							
						'hCC : begin
								start_item(Rad_seq_item);	
								Rad_seq_item.RST = 1;
								assert(Rad_seq_item.randomize(ALU_FUNC));
								finish_item(Rad_seq_item);
								
							
								if (Rad_seq_item.ALU_FUNC == 3)
									begin
										assert(Rad_seq_item.randomize(OP_A));
										assert(Rad_seq_item.randomize(OP_B) with {Rad_seq_item.OP_B != 0;});
									end
								else
									begin
										assert(Rad_seq_item.randomize(OP_A));
										assert(Rad_seq_item.randomize(OP_B));
									end
									
								$display("OP_A = %h", Rad_seq_item.OP_A);
								Sending_Frame(Rad_seq_item.OP_A);
								$display("OP_B = %h", Rad_seq_item.OP_B);
								Sending_Frame(Rad_seq_item.OP_B);
								$display("ALU_FUNC = %d", Rad_seq_item.ALU_FUNC);
								Sending_Frame(Rad_seq_item.ALU_FUNC);	
								
								////////////waiting because the output is sent twice
							repeat(2) begin
								$display("Waiting for monitor");
								monitor_done_event.wait_on();
								monitor_done_event.reset();
								$display("monitor_done_event reset");
								end


							end
						
						'hDD : begin
								start_item(Rad_seq_item);	
								Rad_seq_item.RST = 1;
								assert(Rad_seq_item.randomize(ALU_FUNC));
								finish_item(Rad_seq_item);
	
								$display("ALU_FUNC = %d", Rad_seq_item.ALU_FUNC);
								Sending_Frame(Rad_seq_item.ALU_FUNC);	

									////////////waiting because the output is sent twice
							repeat(2) begin
								$display("Waiting for monitor");
								monitor_done_event.wait_on();
								monitor_done_event.reset();
								$display("monitor_done_event reset");
								end

							end
						endcase
					end
			end
    endtask
	
	
	task Sending_Frame;
	input logic [(DATA_WIDTH_TB-1):0] Frame;
	bit                       parity_in; //just for now (nur fuer gerade)
		begin
			///////////////// sending start bit //////////////////////////////
				start_item(Rad_seq_item);
				Rad_seq_item.RST = 1;
				Rad_seq_item.RX_IN = 1'b0;
				finish_item(Rad_seq_item);
				$display("Sending start bit = %b", Rad_seq_item.RX_IN);
				
				//////////////// sending data ///////////////////////////////////
				
				for (int bits = 0; bits < DATA_WIDTH_TB; bits++)
					begin
						start_item(Rad_seq_item);
						Rad_seq_item.RST = 1;
						Rad_seq_item.RX_IN = Frame[bits];
						finish_item(Rad_seq_item);
						$display("Sending Frame = %b", Rad_seq_item.RX_IN);
					end
				
				
				///////////////////////////Sending Parity////////////////////////
				if(Rad_seq_item.Config[0]) //enable = 1
					begin
						start_item(Rad_seq_item);
						Rad_seq_item.RST = 1;
						parity_calc(Frame, parity_in);
						Rad_seq_item.RX_IN = parity_in;
						finish_item(Rad_seq_item);
						$display("Sending parity bit = %b", Rad_seq_item.RX_IN);
						////Sending Stop Bit 
						start_item(Rad_seq_item);
						Rad_seq_item.RST = 1;
						Rad_seq_item.RX_IN = 1'b1;
						finish_item(Rad_seq_item);
						$display("Sending stop bit = %b", Rad_seq_item.RX_IN);
					end
				//enable = 0 (no parity)
				else    
					begin
						////Sending Stop Bit 
						start_item(Rad_seq_item);
						Rad_seq_item.RST = 1;
						Rad_seq_item.RX_IN = 1'b1;
						finish_item(Rad_seq_item);
						$display("Sending stop bit = %b", Rad_seq_item.RX_IN);
					end
		end
	endtask
	
	task parity_calc;
	input logic  [(DATA_WIDTH_TB-1):0] data;
	output logic correct_parity;
		begin
						if(Rad_seq_item.Config[1])
							begin
								correct_parity = ~(^data); //odd parity
							end
						else
							begin
								correct_parity = (^data); //even parity
							end
		end
	endtask
	
	////////////////////////////to send the new config with the old config/////////////////////////
	task Sending_Config;
	input logic Old_par_en;
	input logic Old_par_typ;
	input logic [(DATA_WIDTH_TB-1):0] new_config;
	bit                       old_config_parity; //parity from the old config
		begin
			///////////////// sending start bit //////////////////////////////
				start_item(Rad_seq_item);
				Rad_seq_item.RST = 1;
				Rad_seq_item.RX_IN = 1'b0;
				finish_item(Rad_seq_item);
				//$display("Sending start bit = %b", Rad_seq_item.RX_IN);
				
				//////////////// sending data ///////////////////////////////////
				
				for (int bits = 0; bits < DATA_WIDTH_TB; bits++)
					begin
						start_item(Rad_seq_item);
						Rad_seq_item.RST = 1;
						Rad_seq_item.RX_IN = new_config[bits];
						finish_item(Rad_seq_item);
						$display("Sending new_config = %b", Rad_seq_item.RX_IN);
					end
				
/////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////Don't forget to check on the parity enable and parity bit first//////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				///////////////////////////Sending Parity////////////////////////
				if(Old_par_en) //enable = 1
					begin
						if(Old_par_typ)
							begin
								old_config_parity = ~(^new_config); //odd parity
								start_item(Rad_seq_item);
								Rad_seq_item.RST = 1;
								Rad_seq_item.RX_IN = old_config_parity;
								finish_item(Rad_seq_item);
								$display("Sending old_config_parity = %b", Rad_seq_item.RX_IN);
								
								////Sending Stop Bit 
								start_item(Rad_seq_item);
								Rad_seq_item.RST = 1;
								Rad_seq_item.RX_IN = 1'b1;
								finish_item(Rad_seq_item);
								$display("Sending stop bit = %b", Rad_seq_item.RX_IN);
							end
						else
							begin
								old_config_parity = (^new_config); //even parity
								start_item(Rad_seq_item);
								Rad_seq_item.RST = 1;
								Rad_seq_item.RX_IN = old_config_parity;
								finish_item(Rad_seq_item);
								$display("Sending old_config_parity = %b", Rad_seq_item.RX_IN);
								
								////Sending Stop Bit 
								start_item(Rad_seq_item);
								Rad_seq_item.RST = 1;
								Rad_seq_item.RX_IN = 1'b1;
								finish_item(Rad_seq_item);
								$display("Sending stop bit = %b", Rad_seq_item.RX_IN);
							end
					end
				//enable = 0 (no parity)
				else    
					begin
						////Sending Stop Bit 
						start_item(Rad_seq_item);
						Rad_seq_item.RST = 1;
						Rad_seq_item.RX_IN = 1'b1;
						finish_item(Rad_seq_item);
						$display("Sending stop bit = %b", Rad_seq_item.RX_IN);
					end
		end
	endtask

endclass
