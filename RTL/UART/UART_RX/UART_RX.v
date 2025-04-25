module UART_RX #(parameter data_width = 8, bits = 3)(

	input wire 		 				 RX_IN_t,
	input wire  	 				 CLK_t, RST_t,
	input wire		 				 Parity_Enable_t,
	input wire		 				 Parity_Type_t,
	input wire  [5:0] 				 Prescale_t,
	input wire                       Stop_Error_t, Parity_Error_t,
	output wire [(data_width - 1):0] P_data_t,
	output wire 		 			 Data_valid_t

);

	wire [4:0] Edge_count_t, Bit_count_t;
	wire       Sampled_bit_t;
	wire	   Start_glitch_t;
	wire	   STR_CK_Enable_t, STP_CK_Enable_t, PRT_CK_Enable_t;
	wire	   Counter_Enable_t, Deser_Enable_t, Sampling_Enable_t;

	
RX_FSM #(.data_width(data_width)) FSM0 (
	.RX_IN(RX_IN_t),
	.CLK(CLK_t), 
	.RST(RST_t),
	.Parity_Enable(Parity_Enable_t),
	.Edge_count(Edge_count_t),
	.Start_glitch(Start_glitch_t),
	.Stop_Error(Stop_Error_t),
	.Parity_Error(Parity_Error_t),
	.Bit_count(Bit_count_t),
	.Prescale(Prescale_t),
	.STR_CK_Enable(STR_CK_Enable_t),
	.STP_CK_Enable(STP_CK_Enable_t),
	.PRT_CK_Enable(PRT_CK_Enable_t),
	.Counter_Enable_reg(Counter_Enable_t),
	.Deser_Enable(Deser_Enable_t),
	.Sampling_Enable_reg(Sampling_Enable_t),
	.Data_valid(Data_valid_t)
);


Data_Sampling DS0 (
	.CLK(CLK_t), 
	.RST(RST_t),
	.RX_IN(RX_IN_t),
	.Prescale(Prescale_t),
	.Enable(Sampling_Enable_t),
	.Edge_count(Edge_count_t),
	.Sampled_bit(Sampled_bit_t)	
);


Edge_Bit_Counter EBC0 (
	.CLK(CLK_t), 
	.RST(RST_t),
	.Enable(Counter_Enable_t),
	.Prescale(Prescale_t),
	.Edge_count(Edge_count_t),
	.Bit_count(Bit_count_t)
);


Deserializer #(.data_width(data_width), .bits(bits)) Deser0 (
	.Enable(Deser_Enable_t),
	.CLK(CLK_t), 
	.RST(RST_t),
	.Bit_count(Bit_count_t),
	.Sampled_bit(Sampled_bit_t),
	.P_data(P_data_t)
);


Start_Check SRT_CH0 (
	.Enable(STR_CK_Enable_t),
	.CLK(CLK_t), 
	.RST(RST_t),
	.Sampled_bit(Sampled_bit_t),
	.Start_glitch(Start_glitch_t)
);


Stop_Check STP_CH0 (
	.Enable(STP_CK_Enable_t),
	.CLK(CLK_t), 
	.RST(RST_t),
	.Sampled_bit(Sampled_bit_t),
	.Stop_Error(Stop_Error_t)
);


Parity_Check #(.data_width(data_width)) PRT_CH0 (
	.Enable(PRT_CK_Enable_t),
	.CLK(CLK_t), 
	.RST(RST_t),
	.Sampled_bit(Sampled_bit_t),
	.Parity_Type(Parity_Type_t),
	.P_data(P_data_t),
	.Parity_Error(Parity_Error_t)
);


endmodule
