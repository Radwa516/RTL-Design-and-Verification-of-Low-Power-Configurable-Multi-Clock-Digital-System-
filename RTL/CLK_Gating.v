module CLK_Gating (
input wire  CLK_REF, 
input wire  Enable,
output wire OUT_CLK
);

reg latch_out;

always@(CLK_REF or Enable)
 begin
   if (!CLK_REF)
     latch_out <= Enable;
 end

assign OUT_CLK = CLK_REF && latch_out;
endmodule