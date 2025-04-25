module DATA_SYNC  #(parameter NUM_STAGES = 2, parameter BUS_WIDTH = 8) (
input wire [BUS_WIDTH-1:0] unsync_bus,
input wire                 bus_enable,
input wire                 CLK,
input wire                 RST,
output reg [BUS_WIDTH-1:0] sync_bus,
output reg                 enable_pulse
);

reg  [NUM_STAGES-1:0] Q;
reg  mul_flop;
wire pulse_gen;
integer n;
 

//MUX
always@(posedge CLK or negedge RST)
 begin
   if (!RST)
     begin
       sync_bus <= 'b0;
     end
   else
     begin
       if (pulse_gen)
         sync_bus <= unsync_bus;
       else
         sync_bus <= sync_bus;
     end
 end
 
 //multi F/F
always@(posedge CLK or negedge RST)
 begin
   if (!RST)
     begin
        mul_flop <= 1'b0;
        Q <= 1'b0;
     end
   else
     begin
       mul_flop <= Q[NUM_STAGES-1]; 
       Q[(NUM_STAGES-1):0] <= {Q[(NUM_STAGES-2):0], bus_enable};
     end
 end
 
//pulse gen
assign pulse_gen = Q[1] & !mul_flop; 

//pulse generated
always @(posedge CLK or negedge RST)
 begin
  if(!RST)     
   begin
    enable_pulse <= 1'b0 ;	
   end
  else
   begin
    enable_pulse <= pulse_gen;
   end  
 end

//bus_enable
always@(posedge CLK or negedge RST)
 begin
   if (!RST)
     begin
       enable_pulse <= 1'b0;
     end
   else
     begin
      enable_pulse <= pulse_gen;
       end
 end

endmodule
