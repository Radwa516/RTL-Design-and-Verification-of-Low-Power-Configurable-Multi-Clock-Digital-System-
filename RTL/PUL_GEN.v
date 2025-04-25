module PUL_GEN (
	input wire  CLK, RST,
	input wire  Sig_in,
	output wire Sig_out
);
reg first_flop, second_flop;

always@(posedge CLK or negedge RST)
 begin
   if(!RST)
     begin
       first_flop <= 1'b0; 
       second_flop <= 1'b0;
     end
   else
     begin
       first_flop <= Sig_in; 
       second_flop <= first_flop;
     end
 end
 
assign Sig_out = !second_flop && first_flop;

endmodule