module Stop_Check (

	input wire 		Enable,
	input wire  	CLK, RST,
	input wire		Sampled_bit,
	output reg		Stop_Error

);

	always@(posedge CLK or negedge RST)
		begin
			if(!RST)
				begin
					Stop_Error <= 1'b0;
				end
			else if(Enable)
				begin
					if(Sampled_bit == 1'b1)
						begin
							Stop_Error <= 1'b0;
						end
					else
						begin
							Stop_Error <= 1'b1;
						end
				end
			else
				begin
					Stop_Error <= 1'b0;
				end
		end

endmodule
