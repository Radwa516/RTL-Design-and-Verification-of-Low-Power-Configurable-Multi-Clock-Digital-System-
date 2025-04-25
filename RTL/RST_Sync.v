module RST_Sync #(parameter NUM_STAGES = 2) (
input wire CLK,
input wire RST,
output reg SYNC_RST
);

reg [NUM_STAGES-1:0] Q;
wire D;

assign  D = 1'b1;

always@(posedge CLK or negedge RST)
 begin
   if(!RST)
     begin
       Q <= 0;
       SYNC_RST <= 0;
     end
   else
     begin
       Q[NUM_STAGES-1] <= D; 
       {Q[(NUM_STAGES-2):0], SYNC_RST} <= Q[(NUM_STAGES-1):0]; 
       //to shift the value of D into SYNC_RST after numbers of clock cycles
       //equal to NUM_STAGES to make syncronous reset de-assertion
     end 
 end

endmodule