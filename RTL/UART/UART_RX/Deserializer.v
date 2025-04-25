module Deserializer #(parameter data_width = 8, bits = 3)(

	input wire						Enable,
	input wire  	 				CLK, RST,
	input wire						Sampled_bit,
	input wire [4:0] 				Bit_count,
	output reg [(data_width - 1):0] P_data

);


	always@(posedge CLK or negedge RST)
		begin
			if(!RST)
				begin
					P_data <= 'b0;
				end
			else if(Enable)
				begin
					P_data[Bit_count-1] <= Sampled_bit;
					//P_data[data_width-1] <= Sampled_bit;
					//P_data <= (P_data >> 1);
				end
		end
/*
	reg [(bits - 1):0] Counter;

	//////////////counter////////
	
	always@(posedge CLK or negedge RST)
		begin
			if(!RST)
				begin
					Counter <= 1'b0;
				end
			else if(Enable)
				begin
					if(Counter == (data_width - 1'b1))
						begin
							Counter <= 1'b0;
						end
					else
						begin
							Counter <= Counter + 1'b1;
						end
				end
			
			else
				begin
					Counter <= 1'b0;
				end
		end
		*/
	//////////////////parallel data//////////////////////
	

endmodule
