module FIFO #(parameter DATA_WIDTH_T = 8,
                        MEM_DEP_T    = 31,
                        ADDR_DATA_T  = 4) (
  input wire                       WR_CLK_T,
  input wire                       WR_RST_T,
  input wire                       RD_CLK_T,
  input wire                       RD_RST_T,
  input wire [(DATA_WIDTH_T-1):0]  WR_data_T,
  input wire                       RD_inc_T,
  input wire                       WR_inc_T,
  output wire                      WR_full_T,
  output wire                      RD_empty_T,
  output wire [(DATA_WIDTH_T-1):0] RD_data_T
);
  
  wire [(ADDR_DATA_T):0]    WR_PTR, RD_PTR;
  wire [(ADDR_DATA_T):0]    WR_PTR_SYNC, RD_PTR_SYNC;
  wire [(ADDR_DATA_T-1):0]  WR_addr_T;
  wire [(ADDR_DATA_T-1):0]  RD_addr_T;
  
  ///////////////////////////FIFO WRITE//////////////////////////////
  FIFO_Write #(.DATA_WIDTH(DATA_WIDTH_T),
               .ADDR_DATA(ADDR_DATA_T)) FIFO_Write0 (
  .WR_inc(WR_inc_T),
  .WR_CLK(WR_CLK_T),
  .WR_RST(WR_RST_T),
  .RD_PTR(RD_PTR_SYNC),
  .WR_full(WR_full_T),
  .WR_PTR_g(WR_PTR),
  .WR_addr(WR_addr_T)
  );
  
  ///////////////////////////FIFO READ////////////////////////////////
  FIFO_Read #(.DATA_WIDTH(DATA_WIDTH_T),
              .ADDR_DATA(ADDR_DATA_T)) FIFO_Read0 (
  .RD_inc(RD_inc_T),
  .RD_CLK(RD_CLK_T),
  .RD_RST(WR_RST_T),
  .WR_PTR(WR_PTR_SYNC),
  .RD_empty(RD_empty_T),
  .RD_PTR_g(RD_PTR),
  .RD_addr(RD_addr_T)
  );
  
  ///////////////////////////FIFO MEM//////////////////////////////////
  FIFO_MEM #(.DATA_WIDTH(DATA_WIDTH_T),
             .MEM_DEP(MEM_DEP_T),
             .ADDR_DATA(ADDR_DATA_T)) FIFO_MEM0 (
  .WR_CLK_EN(WR_inc_T && !WR_full_T),
  .WR_CLK(WR_CLK_T),
  .WR_RST(WR_RST_T),
  .WR_addr(WR_addr_T),
  .RD_addr(RD_addr_T),
  .WR_data(WR_data_T),
  .RD_data(RD_data_T)
  );
  
  ///////////////////////////SYNCRONIZER////////////////////////////////
  ///////////////////////From Write to Read/////////////////////////////
  Syncronizer  #(.ADDR_DATA(ADDR_DATA_T)) Sync_WR2RD(
  .IN(WR_PTR),
  .CLK(RD_CLK_T), 
  .RST(RD_RST_T),
  .SYNC_OUT(WR_PTR_SYNC)
  );
  
  ///////////////////////////SYNCRONIZER////////////////////////////////
  ///////////////////////From Read to Write/////////////////////////////
  Syncronizer  #(.ADDR_DATA(ADDR_DATA_T)) Sync_RD2WR(
  .IN(RD_PTR),
  .CLK(WR_CLK_T), 
  .RST(WR_RST_T),
  .SYNC_OUT(RD_PTR_SYNC)
  );
  
endmodule
