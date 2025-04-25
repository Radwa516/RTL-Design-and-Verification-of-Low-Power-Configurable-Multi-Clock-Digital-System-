module Edge_Bit_Counter (

	input wire  	 CLK, RST,
	input wire		 Enable,
	//input wire		 Parity_Enable,
	input wire [5:0] Prescale,
	output reg [4:0] Edge_count,
	output reg [4:0] Bit_count

);

	
	always@(negedge CLK or negedge RST)
		begin
			if(!RST)
				begin
					Edge_count <= 1'b0;
					Bit_count  <= 1'b0;
				end
				
			else if(Enable)
				begin
					if (Edge_count == (Prescale - 1'b1))
						begin
							Edge_count <= 1'b0;
							Bit_count  <= Bit_count + 1'b1;
						end
						/*
					else if ((Bit_count == 11) && (Parity_Enable == 1) && (Edge_count == 1'b1))
						begin	
							Bit_count  <= 'b0;
						end
					else if ((Bit_count == 10) && (Parity_Enable == 0) && (Edge_count == 1'b1))
						begin	
							Bit_count  <= 'b0;
						end
						*/
					else
						begin
							Edge_count <= Edge_count + 1'b1;
						end					
				end
				
			else
				begin
					Bit_count  <= 1'b0;
					Edge_count <= 1'b0;
				end
		end


endmodule
