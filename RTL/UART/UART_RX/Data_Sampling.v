module Data_Sampling (

	input wire       CLK, RST,
	input wire 		 RX_IN,
	input wire [5:0] Prescale,
	input wire 		 Enable,
	input wire [4:0] Edge_count,
	output reg 		 Sampled_bit
	
);
	wire [4:0] Value;
	reg Sample1, Sample2, Sample3;
	
	assign Value = Prescale >> 1;
	
	always@(posedge CLK or negedge RST)
		begin
			if(!RST)
				begin
					Sample1 <= 1'b1;
					Sample2 <= 1'b1;
					Sample3 <= 1'b1;
				end
			else if(Enable)
				begin
					case(Edge_count)
					(Value - 2'b10): Sample1 <= RX_IN;
					(Value - 1'b1) : Sample2 <= RX_IN;
					(Value)        : Sample3 <= RX_IN;
					//default        : Sample1 = RX_IN;
					endcase
				end
		end
		
	
	always@(*)
		begin
			//if(Sample1 == Sample2 == Sample3 == 1'b1)
			if(Sample1 && Sample2 && Sample3)
				begin
					Sampled_bit = 1'b1;
				end
			//else if (Sample1 == Sample2 == Sample3 == 1'b0)
			else if (!Sample1 && !Sample2 && !Sample3)
				begin
					Sampled_bit = 1'b0;
				end
			else
				begin
					Sampled_bit = ~(Sample1 ^ Sample2 ^ Sample3);  //XNOR
				end
		end



endmodule
