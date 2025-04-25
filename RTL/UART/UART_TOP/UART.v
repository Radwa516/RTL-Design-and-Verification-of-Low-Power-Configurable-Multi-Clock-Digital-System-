module UART # (parameter DATA_WID = 8 , Addr_Width_S = 4) (
input wire        RX_IN,           //RX
input wire  [5:0] UART_Config,     //RX
input wire        RX_CLK,          //RX
output wire [7:0] P_DATA,          //RX
input wire        PAR_TYP_B, PAR_EN_B, //RX
output wire       DATA_VALID,      //RX
output wire       Stop_Error,      //RX
output wire       Parity_Error,    //RX


input wire        RST_SYNC_2,     

input wire [7:0]  RD_DATA,         //TX
input wire        F_EMPITY,        //TX
input wire        TX_CLK,          //TX
output wire       Busy,            //TX
output wire       TX_OUT           //TX
);


//wire [5:0]  PreScale_R;

UART_RX U0_RX (
.Parity_Type_t(PAR_TYP_B),
.Parity_Enable_t(PAR_EN_B),
.RX_IN_t(RX_IN),
.Prescale_t(UART_Config),
.RST_t(RST_SYNC_2), 
.CLK_t(RX_CLK),
.Data_valid_t(DATA_VALID),
.Stop_Error_t(Stop_Error),
.Parity_Error_t(Parity_Error),
.P_data_t(P_DATA)
);


UART_TX U1_TX
(.CLK_T(TX_CLK), 
.RST_T(RST_SYNC_2),
.P_Data_T(RD_DATA),
.Data_Valid_T(!F_EMPITY), 
.PAR_EN_T(PAR_EN_B), 
.PAR_TYP_T(PAR_TYP_B),
.Busy_T(Busy), 
.TX_OUT_T(TX_OUT)
);

endmodule