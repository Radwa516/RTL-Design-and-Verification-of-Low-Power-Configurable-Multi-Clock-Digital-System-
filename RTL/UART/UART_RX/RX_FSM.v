module RX_FSM #(parameter data_width = 8)(

	input wire 		 RX_IN,
	input wire  	 CLK, RST,
	input wire		 Parity_Enable,
	input wire [4:0] Edge_count,
	input wire 		 Start_glitch,
	input wire 		 Stop_Error,
	input wire 		 Parity_Error,
	input wire [4:0] Bit_count,
	input wire [5:0] Prescale,
	output reg 		 STR_CK_Enable,
	output reg 		 STP_CK_Enable,
	output reg 	 	 PRT_CK_Enable,
	output reg 		 Counter_Enable_reg,
	output reg 		 Deser_Enable,
	output reg 		 Sampling_Enable_reg,
	output reg		 Data_valid
	
);

	wire [4:0] Correct_Value;
	reg        Counter_Enable;
	wire  [4:0] Value;
	wire 		Data_Sampling;
	
	assign Value = (Prescale >> 1);
	assign Data_Sampling = (Edge_count == Correct_Value) || (Edge_count == (Correct_Value - 1'b1));
	
	always@(*)
		begin
			case(Edge_count)
				(Value + 2'b10): Sampling_Enable_reg = 1'b1;
				(Value + 2'b01): Sampling_Enable_reg = 1'b1;
				(Value)        : Sampling_Enable_reg = 1'b1;
				(Value - 2'b01): Sampling_Enable_reg = 1'b1;
				(Value - 2'b10): Sampling_Enable_reg = 1'b1;
				default        : Sampling_Enable_reg = 1'b0;
			endcase
		end
	
	
	///use this value to sample or move
	assign Correct_Value = Value + 2'b11; 

	localparam 	IDLE   = 3'd0,
				START  = 3'd1,
				DATA   = 3'd2,
				PARITY = 3'd3,
				STOP   = 3'd4,
				Done   = 3'd5; 
				
				
	reg [2:0] Current_State, Next_State;

	always@(posedge CLK or negedge RST)
		begin
			if(!RST)
				begin
					Current_State <= IDLE;
					Counter_Enable_reg  <= 1'b0;
				end
			else
				begin
					Current_State <= Next_State;
					Counter_Enable_reg  <= Counter_Enable;
				end
		end
		
	always@(*)
		begin
			STR_CK_Enable   = 1'b0;
			STP_CK_Enable   = 1'b0;
			PRT_CK_Enable   = 1'b0;
			Counter_Enable  = 1'b1;
			Deser_Enable    = 1'b0;
			Data_valid      = 1'b0;
			case(Current_State)		
				IDLE   : begin
					if(RX_IN == 1'b0)
						begin
							Next_State      = START;
							STR_CK_Enable   = 1'b0;
						end
					else
						begin
							Next_State 		= IDLE;
							Counter_Enable  = 1'b0;
						end
				end
				
				START  : begin
					if(Start_glitch && (Edge_count == Correct_Value) && (Bit_count == 0))
						begin
							Next_State      = IDLE;
						end
					else if(!Start_glitch && (Edge_count == Correct_Value) && (Bit_count == 0))
						begin
							Next_State   = DATA;
							Counter_Enable  = 1'b1;
						end	
					else
						begin
							Next_State    = START;
							STR_CK_Enable = 1'b1;
						end
				end
				
				DATA   : begin
					if((Bit_count == (data_width + 1)) && (Edge_count == 1'b1))
						begin
							if (Parity_Enable)
								begin
									Next_State    = PARITY;
								end
							else
								begin
									Next_State    = STOP;
								end
						end
					else if((Bit_count != (data_width + 1)) && Data_Sampling)
						begin
							Next_State   = DATA;
							Deser_Enable = 1'b1;
						end
					else 
						begin
							Next_State   = DATA;
							Deser_Enable = 1'b0;
						end
				end
				
				PARITY : begin
					if(Parity_Error && (Edge_count == Correct_Value) && (Bit_count == 9))
						begin
							Next_State      = IDLE;
						end
					if(!Parity_Error && (Edge_count == Correct_Value) && (Bit_count == 9))
						begin
							Next_State    = STOP;
							STP_CK_Enable = 1'b0;
						end	
					else
						begin
							Next_State    = PARITY;
							PRT_CK_Enable = 1'b1;
						end
				end
				
				STOP   : begin
					if(Stop_Error && (Edge_count == Correct_Value))
						begin
							Next_State      = IDLE;
							Counter_Enable  = 1'b0;
						end
					if(!Stop_Error && (Edge_count == Correct_Value))
						begin
							Next_State = Done;
							Data_valid = 1'b0;
							Counter_Enable  = 1'b0;
						end	
					else
						begin
							Next_State    = STOP;
							STP_CK_Enable = 1'b1;
						end
				end
				
				Done   : begin
					Next_State      = IDLE;
					Counter_Enable  = 1'b0;
					Data_valid = 1'b1;
				end
			endcase
		end
		

endmodule
