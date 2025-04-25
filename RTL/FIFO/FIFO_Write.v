module FIFO_Write #(parameter DATA_WIDTH = 8,
                              ADDR_DATA  = 3)(
                              
  input wire                    WR_inc,
  input wire                    WR_CLK,
  input wire                    WR_RST,
  input wire [(ADDR_DATA):0]    RD_PTR,
  output wire                   WR_full,
  output reg [(ADDR_DATA):0]    WR_PTR_g,
  output reg [(ADDR_DATA-1):0]  WR_addr
  
  );
  
  
  wire MS2B, LS1B, LS2B;
  reg [(ADDR_DATA):0]    WR_PTR;
  
  assign MS2B = (RD_PTR[1:0] == WR_PTR_g[1:0]);
  assign LS1B = (RD_PTR[3] != WR_PTR_g[3]);
  assign LS2B = (RD_PTR[2] != WR_PTR_g[2]);
  assign WR_full =  MS2B && LS1B && LS2B;
  
  always@(posedge WR_CLK or negedge WR_RST)
    begin
      if(!WR_RST)
        begin
          //WR_full = 1'b1;
          WR_addr <=  'b0;
          WR_PTR  <=  'b0;
        end
      else if (WR_inc && !WR_full)
        begin
          WR_addr <= WR_addr + 1'b1;
          WR_PTR  <= WR_PTR  + 1'b1;
        end
    end
    
    //always@(posedge WR_CLK or negedge WR_RST)
    always@(*)
    /*
      begin
        if(!WR_RST)
        begin
          WR_PTR_g <= 'b0000;
        end
      else
      */
        begin
        case(WR_PTR)
          'd0    : WR_PTR_g = 'b00000;
          'd1    : WR_PTR_g = 'b00001;
          'd2    : WR_PTR_g = 'b00011;
          'd3    : WR_PTR_g = 'b00010;
          'd4    : WR_PTR_g = 'b00110;
          'd5    : WR_PTR_g = 'b00111;
          'd6    : WR_PTR_g = 'b00101;
          'd7    : WR_PTR_g = 'b00100;
          'd8    : WR_PTR_g = 'b01100;
          'd9    : WR_PTR_g = 'b01101;
          'd10   : WR_PTR_g = 'b01111;
          'd11   : WR_PTR_g = 'b01110;
          'd12   : WR_PTR_g = 'b01010;
          'd13   : WR_PTR_g = 'b01011;
          'd14   : WR_PTR_g = 'b01001;
          'd15   : WR_PTR_g = 'b01000;
		  
		  'd16   : WR_PTR_g = 'b10000;
          'd17   : WR_PTR_g = 'b10001;
          'd18   : WR_PTR_g = 'b10011;
          'd19   : WR_PTR_g = 'b10010;
          'd20   : WR_PTR_g = 'b10110;
          'd21   : WR_PTR_g = 'b10111;
          'd22   : WR_PTR_g = 'b10101;
          'd23   : WR_PTR_g = 'b10100;
          'd24   : WR_PTR_g = 'b11100;
          'd25   : WR_PTR_g = 'b11101;
          'd26   : WR_PTR_g = 'b11111;
          'd27   : WR_PTR_g = 'b11110;
          'd28   : WR_PTR_g = 'b11010;
          'd29   : WR_PTR_g = 'b11011;
          'd30   : WR_PTR_g = 'b11001;
          'd31   : WR_PTR_g = 'b11000;
          default: WR_PTR_g = 'b10000;
		  
        endcase
      //end
    end

endmodule