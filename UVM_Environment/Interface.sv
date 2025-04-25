interface INTF_UART (input bit UART_CLK, input bit REF_CLK);

logic     	RST;
logic     	RX_IN;
logic		TX_OUT;
bit			TX_CLK;
logic		Busy;

logic	[7:0]	Div_Ratio;
logic	[7:0]	P_Data;
logic			RX_Valid;

modport system 	(input RST, RX_IN, output TX_OUT, TX_CLK, Busy, Div_Ratio, P_Data, RX_Valid);
modport driver 	(output RST, RX_IN, input TX_OUT, TX_CLK, Busy, Div_Ratio, P_Data, RX_Valid);

endinterface
