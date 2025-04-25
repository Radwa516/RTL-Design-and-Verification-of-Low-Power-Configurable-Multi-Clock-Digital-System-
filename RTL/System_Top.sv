module System_Top #(parameter DATA_WID_S = 8,
					parameter Addr_Width_S = 4,
					parameter NUM_STAGES_S = 2) 
(  

input wire        UART_CLK,    //System
input wire        REF_CLK,     //sys_ctrl & System
/*
input wire        RST,         //System
input wire        RX_IN,       //RX & System
output wire 	  par_err,     //RX
output wire       stop_err,    //RX
output wire       TX_OUT       //TX & System
*/

INTF_UART.system U_intf
);


wire                     RX_CLK, TX_CLK;
wire                     WrEn_S, RdEn_S;       //from RF
wire [DATA_WID_S-1:0]    RdData_S, WrData_S;   //from RF
wire [Addr_Width_S-1:0]  Address_S;            //from RF
wire                     RdData_Valid_S;       //from RF 
wire                     clk_en;               //internal
wire [DATA_WID_S-1:0]    data;                 //parameter BUS_WIDTH = 8 & sys_ctrl
wire                     EN_pulse;             //between data sync & sys ctrl
wire                     DATA_VALID_S;         //from RX
wire [DATA_WID_S-1:0]    P_DATA_S;             //from RX
wire [DATA_WID_S-1:0]    Div_Ratio;            //internal
wire [5:0]               UART_Config;          //RX
wire       				 par_err, stop_err;    //RX
wire                     PAR_TYP_B; 
wire                     PAR_EN_B;
wire [(2*DATA_WID_S)-1:0]ALU_OUT_S;             //from ALU
wire                     OUT_Valid_S, Enable_S; //from ALU
wire [3:0]               ALU_FUN_S;             //from ALU
wire [DATA_WID_S-1:0]    OP_A, OP_B;            //RF & ALU
wire                     ALU_CLK;               //from ALU & CLK_Gating
wire                     Gate_Enable;           //from CLK_Gating
wire                     Wr_inc, FULL;          //from FIFO
wire                     RD_INC, W_INC;         //from FIFO
wire [DATA_WID_S-1:0]    Fifo_Wr_Data;          //internal & FIFO
wire [DATA_WID_S-1:0]    RD_DATA;               //TX
wire                     F_EMPITY;              //TX
wire                     Busy;                  //TX

///////////////////////////////UART//////////////////////////
UART #(.DATA_WID(DATA_WID_S)) U0_UART  //#(parameter DATA_WID = 8)
(.RX_IN(U_intf.RX_IN),     //RX
.UART_Config(UART_Config), //RX
.RX_CLK(RX_CLK),           //RX
.P_DATA(P_DATA_S),         //RX data          
.DATA_VALID(DATA_VALID_S), //RX data valid     
.Parity_Error(par_err),    //RX
.Stop_Error(stop_err),     //RX                  
.RST_SYNC_2(RST_SYNC_2),
.PAR_TYP_B(PAR_TYP_B), 
.PAR_EN_B(PAR_EN_B),     
.RD_DATA(RD_DATA),         //TX
.F_EMPITY(F_EMPITY),       //TX
.TX_CLK(TX_CLK),           //TX
.Busy(Busy),               //TX
.TX_OUT(U_intf.TX_OUT)     //TX
);

///////////////////////////////TX_CLK////////////////////////////
Clk_Div U0_TX_CLK
(.i_ref_clk(UART_CLK), 
.i_rst_n(RST_SYNC_2),
.i_clk_en(clk_en),
.i_div_ratio(Div_Ratio),  //Div_Ratio = 32 
.o_div_clk(TX_CLK)
);

//////////////////////to use TX_CLK in the driver
assign U_intf.TX_CLK = U0_UART.TX_CLK;
assign U_intf.Busy  = U0_UART.Busy;
assign U_intf.Div_Ratio  = U0_Reg_File.REG2;
assign U_intf.P_Data  = U0_UART.P_DATA;
assign U_intf.RX_Valid  = U0_UART.DATA_VALID;

///////////////////////////////RX_CLK////////////////////////////
Clk_Div U0_RX_CLK
(.i_ref_clk(UART_CLK), 
.i_rst_n(RST_SYNC_2),
.i_clk_en(clk_en),
.i_div_ratio({1'b0, 1'b0, UART_Config}),
.o_div_clk(RX_CLK)
);

///////////////////////////////RST_Sync2////////////////////////////
RST_Sync #(.NUM_STAGES(NUM_STAGES_S)) U0_UART_RST
(.CLK(UART_CLK),
.RST(U_intf.RST),
.SYNC_RST(RST_SYNC_2)
);

///////////////////////////////RST_Sync1////////////////////////////
RST_Sync #(.NUM_STAGES(NUM_STAGES_S)) U0_REF_RST
(.CLK(REF_CLK),
.RST(U_intf.RST),
.SYNC_RST(RST_SYNC_1)
);

///////////////////////////////DATA_SYNC////////////////////////////
DATA_SYNC #(.NUM_STAGES(NUM_STAGES_S),            
             .BUS_WIDTH(DATA_WID_S)) U0_DATA_SYNC      
(.unsync_bus(P_DATA_S),     //data of RX              
.bus_enable(DATA_VALID_S),  //data_valid of RX
.CLK(REF_CLK),          
.RST(RST_SYNC_2),
.sync_bus(data),
.enable_pulse(EN_pulse)
);

/////////////////////////////Reg_File///////////////////////////////
Reg_File #(.Addr_Width(Addr_Width_S), .Mem_Width(DATA_WID_S)) U0_Reg_File
(.Address(Address_S),                              
.WrEn(WrEn_S),                                     
.RdEn(RdEn_S),
.CLK(REF_CLK), 
.RST(RST_SYNC_1),
.WrData(WrData_S),
.RdData(RdData_S),
.RdData_Valid(RdData_Valid_S),
.REG0(OP_A),
.REG1(OP_B),
.REG2({UART_Config, PAR_TYP_B, PAR_EN_B}), 
.REG3(Div_Ratio)
);

////////////////////////////////ALU//////////////////////////////////
ALU #(.Data_Width(DATA_WID_S)) U0_ALU   
(.A(OP_A), 
.B(OP_B),
.ALU_FUN(ALU_FUN_S),
.CLK(ALU_CLK), 
.RST(RST_SYNC_1),
.Enable(Enable_S),
.alu_out(ALU_OUT_S),
.out_valid(OUT_Valid_S)
);

////////////////////////////////CLK_Gating///////////////////////////
CLK_Gating U0_CLK_Gating
(.CLK_REF(REF_CLK), 
.Enable(Gate_Enable),
.OUT_CLK(ALU_CLK)
);

////////////////////////////////FIFO/////////////////////////////////
FIFO #(.DATA_WIDTH_T(DATA_WID_S),
       .ADDR_DATA_T(Addr_Width_S)) U0_FIFo (
.WR_CLK_T(REF_CLK),
.WR_RST_T(RST_SYNC_1),
.RD_CLK_T(TX_CLK),
.RD_RST_T(RST_SYNC_2),
.WR_data_T(Fifo_Wr_Data),
.RD_inc_T(RD_INC),
.WR_inc_T(W_INC),
.WR_full_T(FULL),
.RD_empty_T(F_EMPITY),
.RD_data_T(RD_DATA)
);

////////////////////////////////PUL_GEN for RD_INC//////////////////////////////
PUL_GEN U0_PUL_GEN
(.CLK(TX_CLK), 
.RST(RST_SYNC_2),
.Sig_in(Busy),
.Sig_out(RD_INC)
);

////////////////////////////////PUL_GEN for WR_INC//////////////////////////////
PUL_GEN U1_PUL_GEN
(.CLK(REF_CLK), 
.RST(RST_SYNC_1),
.Sig_in(Wr_inc),
.Sig_out(W_INC)
);

////////////////////////////////SYS_CTRL/////////////////////////////
SYS_CTRL #(.Addr_Width(Addr_Width_S),             
           .Data_Width(DATA_WID_S)) U0_SYS_CTRL  
(.RX_P_Data(data),             //from RX (input)  
.RX_D_VLD(EN_pulse),           //from RX (input)
.TX_D_VLD(Busy),               //from TX (input)
.REF_CLK(REF_CLK),             //(input)
.RST(RST_SYNC_1),              //(input)
.clk_div_en(clk_en),           //from Clk_Div (output)
.RdData_Valid(RdData_Valid_S), //from RF (input)  
.RdData(RdData_S),             //from RF (input)
.WrData(WrData_S),             //from RF (output)
.Address(Address_S),           //from RF (output)
.Wr_En(WrEn_S),                //from RF (output)
.Rd_En(RdEn_S),                //from RF (output)
.ALU_OUT(ALU_OUT_S),           //from ALU (input)
.OUT_Valid(OUT_Valid_S),       //from ALU (input)
.Enable(Enable_S),             //from ALU (output)
.ALU_FUN(ALU_FUN_S),           //from ALU (output)
.Gate_EN(Gate_Enable),         //from CLK_Gating (output)
.Fifo_Full(FULL),              //(input)
.WR_INC(Wr_inc),               //(output)
.Fifo_Wr_Data(Fifo_Wr_Data)    //from FIFO (output)
);

endmodule
