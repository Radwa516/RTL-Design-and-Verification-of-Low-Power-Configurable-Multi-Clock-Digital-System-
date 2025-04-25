module Syncronizer #(parameter ADDR_DATA = 3)(
  
  input wire [(ADDR_DATA):0] IN,
  input wire                 CLK, RST,
  output reg [(ADDR_DATA):0] SYNC_OUT
  
  );
  
  reg [(ADDR_DATA):0] bridge;
  ///////////////////////////first flop///////////////////////////
  always@(posedge CLK or negedge RST)
    begin
      if(!RST)
        begin
          bridge <= 1'b0;
        end
      else
        begin
          bridge <= IN;
        end
    end
    
  ////////////////////////second flop/////////////////////////  
  always@(posedge CLK or negedge RST)
    begin
      if(!RST)
        begin
          SYNC_OUT <= 1'b0;
        end
      else
        begin
          SYNC_OUT <= bridge;
        end
    end
  
 
endmodule
