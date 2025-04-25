module Parity_Calc (
	input wire [7:0] store,
	input wire       PAR_TYP, busy,
	output reg       par_bit
);

//reg [2:0] counter;
//integer i;
/*
always@(*)
 begin
   if(busy)
     begin
       counter = 3'b0;
       for (i=0; i<8; i=i+1)
        begin
          if (store[i] == 8'b1)
          counter = counter + 3'b1;
        else 
          counter = counter + 3'b0;
         end
     end
   else
     counter = 3'b0;
 end

 always@(*)
  begin
    if (PAR_TYP == 1'b0)
      begin
        if (counter%2 == 3'b000)  //even
          par_bit = 1'b0;
        else               
          par_bit = 1'b1;
      end
      
  else 
      begin
        if (counter%2 == 3'b000) // odd
          par_bit = 1'b1;
        else
          par_bit = 1'b0;
      end
  end
*/
	always@(*)
		begin
					if (PAR_TYP == 0)
						begin
							par_bit <= (^store);
						end
					else
						begin
							par_bit <= ~(^store);
						end
		end

endmodule
