module Parity_Check #(parameter data_width = 8)(

	input wire 						Enable,
	input wire  					CLK, RST,
	input wire						Sampled_bit,
	input wire						Parity_Type,
	input wire [(data_width - 1):0] P_data,
	output reg						Parity_Error

);

	reg Correct_Parity;
	
	always@(posedge CLK or negedge RST)
		begin
			if(!RST)
				begin
					Parity_Error <= 1'b0;
				end
			else if(Enable)
				begin
					if(Sampled_bit == Correct_Parity)
						begin
							Parity_Error <= 1'b0;
						end
					else
						begin
							Parity_Error <= 1'b1;
						end
				end
			else
				begin
					Parity_Error <= 1'b0;
				end
		end
		
	///////////calculate the parity///////////
	
	always@(posedge CLK)
		begin
			if(Enable)
				begin
					if(Parity_Type == 0)  //even
						begin
							Correct_Parity <= (^P_data); ///XNOR
							//Correct_Parity <= 0; ///XNOR
						end
					else
						begin
							Correct_Parity <= ~(^P_data);  ///XOR
							//Correct_Parity <= (^P_data);  ///XOR
						end
				end
		end
	
		
		
endmodule
