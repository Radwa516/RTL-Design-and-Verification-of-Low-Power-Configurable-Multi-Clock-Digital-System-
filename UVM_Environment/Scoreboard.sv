///////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////Scoreboard////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Import the DPI function at the top level (outside class)
import "DPI-C" function shortint process_data(input shortint data[4]);


class Radwa_scoreboard extends uvm_scoreboard;

	`uvm_component_utils (Radwa_scoreboard)
	Radwa_sequence_item in_seq_1;	
	Radwa_sequence_item in_seq_2;
	////////////////////tlm
	uvm_analysis_export   	#(Radwa_sequence_item) analysis_export_1;
	uvm_analysis_export    	#(Radwa_sequence_item) analysis_export_2;
	uvm_tlm_analysis_fifo  	#(Radwa_sequence_item) in_fifo_1;
	uvm_tlm_analysis_fifo  	#(Radwa_sequence_item) in_fifo_2;
	
	
/////////////////////////////////////////////////new///////////////////////////////////////////////////////////
	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction


/////////////////////////////////////////////build_phase///////////////////////////////////////////////////////
      function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		$display("build phase of scoreboard");
		analysis_export_1 = new("analysis_export_1", this);
		analysis_export_2 = new("analysis_export_2", this);
		in_fifo_1 = new("in_fifo_1", this);
		in_fifo_2 = new("in_fifo_2", this);
    endfunction


///////////////////////////////////////////connect_phase///////////////////////////////////////////////////////
    function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		analysis_export_1.connect(in_fifo_1.analysis_export);
		analysis_export_2.connect(in_fifo_2.analysis_export);
		$display("connect phase of scoreboard");
    endfunction


////////////////////////////////////////////run_phase//////////////////////////////////////////////////////////
    task run_phase(uvm_phase phase);
		logic OUT[$];
		shortint IN[$];
		logic garbig;
		logic start_bit;
		logic stop_bit;
		logic parity_bit;
		logic [(DATA_WIDTH_TB-1):0] data;
		logic [(DATA_WIDTH_TB-1):0] gen_data;
		logic [(DATA_WIDTH_TB-1):0] data_container[$];
		logic [(2*DATA_WIDTH_TB-1):0] result;
		shortint arr[4];
		
		bit [(DATA_WIDTH_TB-1):0] OP_A;
		bit [(DATA_WIDTH_TB-1):0] OP_B;
        super.run_phase(phase);
	    $display("run phase of scoreboard");
		
		fork
			forever begin
				in_fifo_2.get(in_seq_2);
				IN.push_back(in_seq_2.P_Data);
				$display("From scoreboard Input = %p", IN);
				case(IN[0])
				'hAA	: begin
							if (IN.size() == 3) 
								begin 
									$display("From scoreboard Input = %p", IN);
									for (int y = 0; y < 3; y++) begin
										arr[y] = IN.pop_front();
										arr[3] = 0;
									end
							foreach (arr[i])
								$display("arr[%0d] = %0h", i, arr[i]);
					
							result = process_data(arr);
							$display("From scoreboard result = %d also Input = %p", result, IN);
								end
				end
				'h00	: begin
							IN.pop_front();
				end
				
				'hBB	: begin
							if (IN.size() == 2) 
								begin 
									$display("From scoreboard Input = %p", IN);
									for (int y = 0; y < 2; y++) begin
										arr[y] = IN.pop_front();
										arr[2] = 0;
										arr[3] = 0;
									end
							foreach (arr[i])
								$display("arr[%0d] = %0h", i, arr[i]);
					
							result = process_data(arr);
							$display("From scoreboard result = %d also Input = %p", result, IN);
							gen_data = data_container.pop_front();
							Check_data(gen_data, result[7:0]);
								end
				end
				'hCC	: begin
							if (IN.size() == 4) 
								begin 
									$display("From scoreboard Input = %p", IN);
									for (int y = 0; y < 4; y++) begin
										arr[y] = IN.pop_front();
									end
							foreach (arr[i])
								$display("arr[%0d] = %0h", i, arr[i]);
					
							result = process_data(arr);
							$display("From scoreboard result = %d also Input = %p", result, IN);
							gen_data = data_container.pop_front();
							Check_data(gen_data, result[7:0]);
							gen_data = data_container.pop_front();
							Check_data(gen_data, result[15:8]);
								end
				end
				'hDD	: begin
							if (IN.size() == 2) 
								begin 
									$display("From scoreboard Input = %p", IN);
									for (int y = 0; y < 2; y++) begin
										arr[y] = IN.pop_front();
										arr[2] = 0;
										arr[3] = 0;
									end
							foreach (arr[i])
								$display("arr[%0d] = %0h", i, arr[i]);
					
							result = process_data(arr);
							$display("From scoreboard result = %d also Input = %p", result, IN);
							gen_data = data_container.pop_front();
							Check_data(gen_data, result[7:0]);
							gen_data = data_container.pop_front();
							Check_data(gen_data, result[15:8]);
								end
				end
				
				default : begin
							$error("There is unexpected data");
				end
				endcase
			end
			
			forever begin
			in_fifo_1.get(in_seq_1);
			if(in_seq_1.RST == 1'b0)
				begin
					$display("The RST is on");
					continue;
				end
			OUT.push_back(in_seq_1.TX_OUT);
			$display("From scoreboard Output = %p", OUT);
			
			if(in_seq_1.Div_Ratio[0] == 1'b1)
					begin
						if (OUT.size() == (DATA_WIDTH_TB + 4)) ////change 3 based on parity enable
							begin
								garbig = OUT.pop_front();
								start_bit = OUT.pop_front();
								for (int bits = 0; bits < DATA_WIDTH_TB; bits++)
									begin
										data[bits] = OUT.pop_front();
									end
								$display(" From scoreboard data = %d", data);
								data_container.push_back(data);
								$display(" From scoreboard data_container = %p", data_container);
								
								parity_bit = OUT.pop_front();  
								stop_bit   = OUT.pop_front();
						
								Check(start_bit, stop_bit, parity_bit, data);
							end
					end
				else
					begin
						if (OUT.size() == (DATA_WIDTH_TB + 3)) 
							begin
								garbig = OUT.pop_front();
								start_bit = OUT.pop_front();
								for (int bits = 0; bits < DATA_WIDTH_TB; bits++)
									begin
										data[bits] = OUT.pop_front();
									end
								$display(" From scoreboard data = %d", data);
								data_container.push_back(data);
								$display(" From scoreboard data_container = %p", data_container);
								
								parity_bit = 0;  /////////just any value (for the task) (but it won't be used)
								stop_bit   = OUT.pop_front();
						
								Check(start_bit, stop_bit, parity_bit, data);
							end
					end
			end
			join
			
	    endtask
		
		
		task Check_data;
		input logic [(DATA_WIDTH_TB-1):0]  gen_data;
		input logic [(DATA_WIDTH_TB-1):0]  exp_data;
			begin
				if(gen_data == exp_data)
					begin
						$display("From scoreboard Data Check is Passed");
						$display("From Scoreboard Data Gen is: %d", gen_data);
						$display("From Scoreboard Data Exp is: %d", exp_data);
					end
				else
					begin
						$fatal("From scoreboard Data Check is Failed with Data Gen is: %d & Data Exp is: %d", gen_data, exp_data);
					end
			end
		endtask
		
		
		task Check;
		//////////in meaning in this task
		input logic start_bit_in;
		input logic stop_bit_in;
		input logic parity_bit_in;
		input logic [(DATA_WIDTH_TB-1):0] data_in;
		logic 		correct_parity;
		
			begin
			/////////////////////Start Bit/////////////////////////////////////
				if (start_bit_in == 0)
					begin
						//$display("From scoreboard Start Bit Check is Passed");
					end
				else
					begin
						$fatal(" From scoreboard Start Bit Check is Failed with value", start_bit_in);
					end
			
			////////////////////Parity Calc////////////////////////////////////
			if((in_seq_1.Div_Ratio[1] == 1'b1) && (in_seq_1.Div_Ratio[0] == 1'b1))
							begin
								correct_parity = ~(^data_in); //odd parity
							end
						else
							begin
								correct_parity = (^data_in); //even parity
							end
							
			/////////////////parity check/////////////////////////////////////
			if(in_seq_1.Div_Ratio[0] == 1'b1)
				begin
					if (parity_bit_in == correct_parity)
						begin
							$display("From scoreboard Parity Bit Check is Passed");
						end
					else
						begin
							$fatal(" From scoreboard Parity Bit Check is Failed with value", parity_bit_in);
						end			
					
					/////////////////////Stop Bit/////////////////////////////////////			
					if (stop_bit_in == 1)
						begin
							//$display("From scoreboard Stop Bit Check is Passed");
						end
					else
						begin
							$fatal(" From scoreboard Stop Bit Check is Failed with value", stop_bit_in);
						end
				end
			else
				begin
					/////////////////////Stop Bit/////////////////////////////////////			
					if (stop_bit_in == 1)
						begin
							//$display("From scoreboard Stop Bit Check is Passed");
						end
					else
						begin
							$fatal(" From scoreboard Stop Bit Check is Failed with value", stop_bit_in);
						end
				end
			
			end		
		endtask

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

	function void write (Radwa_sequence_item t);
		$display("This is write function from scoreboard");
	endfunction

endclass

