module FIFO_Read #(parameter DATA_WIDTH = 8,
                              ADDR_DATA  = 3)(
                              
  input wire                    RD_inc,
  input wire                    RD_CLK,
  input wire                    RD_RST,
  input wire [(ADDR_DATA):0]    WR_PTR,
  output wire                   RD_empty,
  output reg [(ADDR_DATA):0]    RD_PTR_g,
  output reg [(ADDR_DATA-1):0]  RD_addr
  
  );
  
  reg [(ADDR_DATA):0]    RD_PTR;
  
  assign RD_empty = (RD_PTR_g == WR_PTR);

  always@(posedge RD_CLK or negedge RD_RST)
    begin
      if(!RD_RST)
        begin
          RD_addr <=  'b0;
          RD_PTR  <=  'b0;
        end
      else if (RD_inc && !RD_empty)
        begin
          RD_addr <= RD_addr + 1'b1;
          RD_PTR  <= RD_PTR  + 1'b1;
        end
    end

  //always@(posedge RD_CLK or negedge RD_RST)
  always@(*)
  /*
      begin
        if(!RD_RST)
        begin
          RD_PTR_g <= 'b0000;
        end
      else */
        begin
        case(RD_PTR)
          'd0    : RD_PTR_g = 'b00000;
          'd1    : RD_PTR_g = 'b00001;
          'd2    : RD_PTR_g = 'b00011;
          'd3    : RD_PTR_g = 'b00010;
          'd4    : RD_PTR_g = 'b00110;
          'd5    : RD_PTR_g = 'b00111;
          'd6    : RD_PTR_g = 'b00101;
          'd7    : RD_PTR_g = 'b00100;
          'd8    : RD_PTR_g = 'b01100;
          'd9    : RD_PTR_g = 'b01101;
          'd10   : RD_PTR_g = 'b01111;
          'd11   : RD_PTR_g = 'b01110;
          'd12   : RD_PTR_g = 'b01010;
          'd13   : RD_PTR_g = 'b01011;
          'd14   : RD_PTR_g = 'b01001;
          'd15   : RD_PTR_g = 'b01000;
		  
		  'd16   : RD_PTR_g = 'b10000;
          'd17   : RD_PTR_g = 'b10001;
          'd18   : RD_PTR_g = 'b10011;
          'd19   : RD_PTR_g = 'b10010;
          'd20   : RD_PTR_g = 'b10110;
          'd21   : RD_PTR_g = 'b10111;
          'd22   : RD_PTR_g = 'b10101;
          'd23   : RD_PTR_g = 'b10100;
          'd24   : RD_PTR_g = 'b11100;
          'd25   : RD_PTR_g = 'b11101;
          'd26   : RD_PTR_g = 'b11111;
          'd27   : RD_PTR_g = 'b11110;
          'd28   : RD_PTR_g = 'b11010;
          'd29   : RD_PTR_g = 'b11011;
          'd30   : RD_PTR_g = 'b11001;
          'd31   : RD_PTR_g = 'b11000;
          default: RD_PTR_g = 'b10000;
        endcase
		//end
      end

endmodule