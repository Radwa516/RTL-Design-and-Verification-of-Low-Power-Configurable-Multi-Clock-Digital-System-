module Clk_Div (
 input wire       i_ref_clk, i_rst_n,
 input wire       i_clk_en,
 input wire [7:0] i_div_ratio,
 output reg       o_div_clk
);

 integer    counter;
 reg        EV_OD, flag;
 wire       enable, up, dn;
 wire [3:0] divition, div_1;
 reg        Clk_Div;
 reg  [7:0] ratio;

///////////////////enable for clock divider///////////////////////

 assign enable = (i_clk_en == 1'b1 && ratio != 'b0 && ratio != 'b1);

////////////////condion of up & down in the case of odd number/////////////
 assign dn = !EV_OD && ((counter == divition) && !flag); 
 assign up = !EV_OD && ((counter == div_1) && flag);

////////////////////divition//////////////////////

assign divition = ratio >> 1;
assign div_1 = divition - 1;

/////////////////clock divider/////////////////////

always@(posedge i_ref_clk or negedge i_rst_n)
 begin
   if (!i_rst_n)
     begin
      Clk_Div <= 1'b0;
      flag    <=  1'b1;
     end
   else if (enable)
     begin
       if (EV_OD && counter == div_1) //even condition
        begin
         Clk_Div <= !Clk_Div;
         flag    <= 1'b0;
        end
       else if (up || dn) //odd condition
        begin
         Clk_Div <= !Clk_Div;
         flag    <= !flag;
         end
      end
    else
        begin
         Clk_Div <= 1'b0;
         flag    <= 1'b0;
        end
 end
 
//////////////////////counter///////////////

 always@(posedge i_ref_clk or negedge i_rst_n)
  begin
   if (!i_rst_n)
     counter <= 'b0;
   else if ((enable && (up || dn)) || (enable && (EV_OD && counter == div_1)))
     counter <= 'b0;
   else if (enable) 
     counter <= counter + 'b1;
   else
     counter <= 'b0;
  end
 
////////////////////////EVEN or ODD//////////////////

 always@(*)
  begin
   if (ratio%2 == 0)
     begin 
       EV_OD = 1'b1;  // if it is even
     end
   else
     begin 
       EV_OD = 1'b0; // if it is odd
     end
  end
 ////////////////o_div_clk/////////////////
 
 always@(*)
  begin
    if (enable)
      o_div_clk = Clk_Div; // new clock
    else
      o_div_clk = i_ref_clk;  // normal case
  end
  
///////////////convert i_div_ratio to ratio//////////////
 always@(*)
  begin
   case (i_div_ratio)
     8'd32: ratio = 6'b1;
     8'd16: ratio = 6'b10;
     8'd8: ratio  = 6'b100;
     8'd4: ratio  = 6'b1000;
     8'd1: ratio  = 6'd32; //special for tx until i put the mux
     default: ratio = 6'b1;
    endcase
  end
 endmodule
