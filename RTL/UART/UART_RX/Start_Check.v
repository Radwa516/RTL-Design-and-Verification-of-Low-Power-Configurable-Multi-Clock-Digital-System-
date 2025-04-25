module Start_Check (

	input wire 		Enable,
	input wire  	CLK, RST,
	input wire		Sampled_bit,
	output reg		Start_glitch

);

	always@(posedge CLK or negedge RST)
		begin
			if(!RST)
				begin
					Start_glitch <= 1'b0;
				end
			else if(Enable)
				begin
					if(Sampled_bit == 1'b0)
						begin
							Start_glitch <= 1'b0;
						end
					else
						begin
							Start_glitch <= 1'b1;
						end
				end
			else
				begin
					Start_glitch <= 1'b0;
				end
		end


endmodule
