module UART_TX (
input wire       CLK_T, RST_T,
input wire [7:0] P_Data_T,
input wire       Data_Valid_T, 
input wire       PAR_EN_T, PAR_TYP_T,
output wire      Busy_T, TX_OUT_T
);

wire [1:0] mux_sel_T;
wire [7:0] store_T;
wire       ser_data_T, par_bit_T; 
wire       ser_en_T, ser_done_T;
wire       start_bit_T, stop_bit_T;

serializer U0_serializer
(.P_Data(P_Data_T), 
.ser_en(ser_en_T),
.CLK(CLK_T), 
.RST(RST_T),
.Data_Valid(Data_Valid_T),
.ser_data(ser_data_T),
.ser_done(ser_done_T),
.store(store_T)
);

FSM_TX U0_FSM_TX
(.Data_Valid(Data_Valid_T), 
.PAR_EN(PAR_EN_T), 
.ser_done(ser_done_T),
.CLK(CLK_T), 
.RST(RST_T),
.ser_en(ser_en_T), 
.mux_sel(mux_sel_T),
.busy(Busy_T)
);

Parity_Calc U0_Parity_Calc
(.store(store_T),
//.P_Data(P_Data_T), 
.busy(Busy_T), 
//.Data_Valid(Data_Valid_T),
.PAR_TYP(PAR_TYP_T), 
//.PAR_EN(PAR_EN_T),
.par_bit(par_bit_T)
);

MUX U0_MUX
(//.CLK(CLK_T), 
.RST(RST_T),
.ser_data(ser_data_T), 
.par_bit(par_bit_T), 
.mux_sel(mux_sel_T),
.TX_OUT(TX_OUT_T)
//.ser_done(ser_done_T)
//.Data_Valid(Data_Valid_T)
);
endmodule

