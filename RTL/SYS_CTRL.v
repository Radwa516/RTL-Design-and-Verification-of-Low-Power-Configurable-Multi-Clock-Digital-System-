module SYS_CTRL #(parameter Data_Width = 8,
                  //parameter Mem_Depth = 16,
                  parameter Addr_Width = 4) (
	input wire [Data_Width-1:0]     RX_P_Data,       //from RX
	input wire                      RX_D_VLD,        //from RX
	input wire                      TX_D_VLD,        //from TX
	input wire                      REF_CLK, RST,   
	output wire                     clk_div_en,      //from Clk_Div
	input wire                      RdData_Valid,    //from RF    
	input wire [Data_Width-1:0]     RdData,          //from RF
	output reg [Data_Width-1:0]     WrData,          //from RF
	output reg [Addr_Width-1:0]     Address,         //from RF
	output reg                      Wr_En, Rd_En,    //from RF
	input wire [(2*Data_Width)-1:0] ALU_OUT,         //from ALU
	input wire                      OUT_Valid,       //from ALU
	output reg                      Enable,          //from ALU
	output reg [Addr_Width-1:0]     ALU_FUN,         //from ALU
	output reg                      Gate_EN,         //from CLK_Gating
	input wire                      Fifo_Full,       //from FIFO
	output reg                      WR_INC,          //from FIFO
	output reg [Data_Width-1:0]     Fifo_Wr_Data     //from FIFO
);

	reg [3:0] current_state, next_state;
	reg       WrEn, RdEn;

	localparam 	IDLE       = 4'd1,
				RF_WR_Addr = 4'd2,
				RF_WR_Data = 4'd3,
				RF_RD_Addr = 4'd4,
				OP_A 	  = 4'd5,
				OP_B 	  = 4'd6,
				ALU_FUNC   = 4'd7,
				Final 	  = 4'd8,
				AA 		  = 4'd9,
				BB 		  = 4'd10,
				CC 		  = 4'd11,
				DD 		  = 4'd12,
				WAIT 	  = 4'd13,
				Final2     = 4'd14;

////////////////////clk_div_en//////////////////

	assign clk_div_en = 1'b1;

/////////////////////////////////////////////////
	always@(posedge REF_CLK or negedge RST)
		begin
			if(!RST)
				begin
					current_state <= IDLE;
					Wr_En <= 'b0; 
					Rd_En <= 'b0;
				end
			else
				begin
					current_state <= next_state;
					Wr_En <= WrEn; 
					Rd_En <= RdEn;
				end
		end
	
///////////////////////////next state logic/////////////////////
	always@(*)
		begin
			Enable = 1'b0;        
			ALU_FUN = 4'b1111;
			WrData = WrData;
			Address = Address;
			WrEn = 1'b0; 
			RdEn = 1'b0;
			Fifo_Wr_Data = RdData;
			Gate_EN = 1'b0;
			WR_INC = 1'b0;
			case(current_state)
				IDLE: begin
						case(RX_P_Data)
						'hAA   : next_state = AA;
						'hBB   : next_state = BB;
						'hCC   : next_state = CC;
						'hDD   : next_state = DD;
						default: next_state = IDLE;
						endcase
				end
      
				AA: begin
					if(RX_D_VLD)
						begin
							next_state = RF_WR_Addr;
						end
					else
						begin
							next_state = AA;
						end
				end
           
				RF_WR_Addr: begin
					if (RX_D_VLD && !Fifo_Full)
						begin
							next_state = RF_WR_Data;
							WrEn = 1'b1;
						end
					else
						begin
							next_state = RF_WR_Addr;
							WrData = WrData;
							Address = RX_P_Data;
							WrEn = 1'b0; 
							WR_INC = 1'b0;
							RdEn = 1'b0;
							Fifo_Wr_Data = RdData;
						end
				end
           
				RF_WR_Data: begin
					if (RX_D_VLD)
						begin
							next_state = IDLE;
						end
					else
						begin
							next_state = RF_WR_Data;
							WrData = RX_P_Data;
							Address = Address;
							WrEn = 1'b0; 
							WR_INC = 1'b0;
							RdEn = 1'b0;
							Fifo_Wr_Data = RdData;
						end
				end
				
				BB: begin
					if(RX_D_VLD)
						begin
							next_state = RF_RD_Addr;
							RdEn = 1'b1;
						end
					else
						begin
							next_state = BB;
						end
				end
           
				RF_RD_Addr: begin
					if (RX_D_VLD)
						begin
							next_state = IDLE;
						end
					else
						begin
							next_state = RF_RD_Addr;
							WrData = WrData;
							Address = RX_P_Data;
							WrEn = 1'b0; 
							WR_INC = 1'b1;
							RdEn = 1'b0;
							Fifo_Wr_Data = RdData;
						end
				end
      
				CC: begin
					if(RX_D_VLD && !Fifo_Full)
						begin
							next_state = OP_A;
							WrEn = 1'b1;
							WR_INC = 1'b0;
							Gate_EN = 1'b1;
						end
					else
						begin
							next_state = CC;
						end
				end
      
				OP_A: begin
					if (RX_D_VLD && !Fifo_Full)
						begin
							next_state = OP_B;
							Gate_EN = 1'b1;
							Enable = 1'b0;        
							ALU_FUN = 4'b1111;  
							WrData = WrData;
							Address = 'd1;
							WrEn = 1'b1; 
							WR_INC = 1'b0;
							RdEn = 1'b0;
							Fifo_Wr_Data = RdData; 
						end
					else
						begin
							next_state = OP_A;
							WrData = RX_P_Data;
							Address = 'b0;
							Gate_EN = 1'b1;
							WrEn = 1'b0; 
							WR_INC = 1'b0;
							RdEn = 1'b0;
							Fifo_Wr_Data = RdData;
						end
				end
            
				OP_B: begin
					if (RX_D_VLD && !Fifo_Full)
						begin
							next_state = ALU_FUNC;
							Gate_EN = 1'b1;
							//WrEn = 1'b1;
						end
					else
						begin
							next_state = OP_B;
							Gate_EN = 1'b1;
							Enable = 1'b0; 
							WrData = RX_P_Data;
							Address = 'd1;
							WrEn = 1'b0;
							WR_INC = 1'b0; 
							RdEn = 1'b0;
							Fifo_Wr_Data = RdData;
						end
				end
            
				DD: begin
					if(RX_D_VLD)
						begin
							next_state = ALU_FUNC;
							Gate_EN = 1'b1;
							//WrEn = 1'b1;
						end
					else
						begin
							next_state = DD;
						end
				end
            
				ALU_FUNC: begin
					if (TX_D_VLD)   //Busy
						begin
							next_state = WAIT;
						end
					else
						begin
							next_state = ALU_FUNC;
							Gate_EN = 1'b1;
							Enable = 1'b1;        
							ALU_FUN = RX_P_Data;
							WrData = WrData;
							//Address = 'd7;
							WrEn = 1'b0;
							WR_INC = 1'b1; 
							RdEn = 1'b0;
							Fifo_Wr_Data = ALU_OUT[Data_Width-1:0];    
						end
               end
			   
      ////////just to wait untill TX_OUT finshed
				WAIT: begin
					if (!TX_D_VLD)   //Busy
						begin
							next_state = Final;
							WrEn = 1'b0;
						end
					else
						begin
							next_state = WAIT;
							Gate_EN = 1'b0;
							Enable = 1'b0;        
							ALU_FUN = RX_P_Data;
							WrData = WrData;
							//Address = 'd7;
							WrEn = 1'b0;
							WR_INC = 1'b0; 
							RdEn = 1'b0;
							Fifo_Wr_Data = ALU_OUT[Data_Width-1:0];    
						end
				end
      
				Final: begin
					if (TX_D_VLD)
						begin
							next_state = Final2;
							WrEn = 1'b0;
						end
					else
						begin
							next_state = Final;
							Gate_EN = 1'b0;
							Enable = 1'b0;        
							ALU_FUN = RX_P_Data;
							WrData = WrData;
							//Address = 'd8;
							WrEn = 1'b0;
							WR_INC = 1'b1; 
							RdEn = 1'b0;
							Fifo_Wr_Data = ALU_OUT[(2*Data_Width)-1:Data_Width];    
						end
				end
	   
				Final2: begin
					if (!TX_D_VLD)
						begin
							next_state = IDLE;
						end
					else
						begin
							next_state = Final2;
							Gate_EN = 1'b0;
							Enable = 1'b0;        
							ALU_FUN = RX_P_Data;
							WrData = WrData;
							//Address = 'd8;
							WrEn = 1'b0;
							Fifo_Wr_Data = ALU_OUT[(2*Data_Width)-1:Data_Width];    
						end
				end
	   
			endcase
	end


endmodule