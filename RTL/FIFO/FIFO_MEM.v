module FIFO_MEM #(parameter DATA_WIDTH = 8,
                            MEM_DEP    = 31,
                            ADDR_DATA  = 3) (
  input wire                     WR_CLK_EN,
  input wire                     WR_CLK,
  input wire                     WR_RST,
  input wire  [(ADDR_DATA-1):0]  WR_addr,
  input wire  [(ADDR_DATA-1):0]  RD_addr,
  input wire  [(DATA_WIDTH-1):0] WR_data,
  output wire [(DATA_WIDTH-1):0] RD_data
 
  );
  
  reg [(DATA_WIDTH-1):0] memory [(MEM_DEP-1):0];
  integer i;
  
  always@(posedge WR_CLK or negedge WR_RST)
    begin
      if(!WR_RST)
        begin
          for (i=0; i<32; i=i+1)
            begin
              memory[i] <= 'b0;
            end
        end
      else if (WR_CLK_EN)
        begin
          memory [WR_addr] <= WR_data;
        end
    end

  assign RD_data = memory [RD_addr];

endmodule