module FSM_TX (
input wire       Data_Valid, 
input wire       PAR_EN,
input wire       ser_done,
input wire       CLK, RST,
output reg       ser_en, 
output reg [1:0] mux_sel,
output reg       busy
);

reg        BUSY, SER_EN;
reg [2:0]  current_state, next_state;
reg [1:0]  MUX_SEL; 

localparam [2:0] IDLE = 3'b000,
                 START = 3'b010,
                 DATA = 3'b011,
                 PAR = 3'b001,
                 STOP = 3'b101;
           
always@(posedge CLK or negedge RST)
 begin
   if (!RST)
     begin
     busy <= 0;
     current_state <= IDLE;
     ser_en <= 0;
     mux_sel <= 2'b00;
     end
   else
     begin
     busy <= BUSY;
     current_state <= next_state;
     ser_en <= SER_EN;
     mux_sel <= MUX_SEL;
     end
 end
 
always@(*)
 begin
   case(current_state)
     IDLE: begin
       if(Data_Valid)
         next_state = START;
       else
         next_state = IDLE;
     end
     
     START: begin
         next_state = DATA;
     end
      DATA: begin
      if (ser_done)  
         begin
          if (PAR_EN)  
        next_state = PAR;
          else 
        next_state = STOP;
          end 
      else 
       next_state = DATA;
            end
     
      PAR: begin
        next_state  = STOP;
     end
     
      STOP: begin
        next_state = IDLE;
     end
     
      default: begin
        next_state = IDLE;
               end
   endcase
 end

always@(*)
 begin
   case(current_state)
     IDLE: begin
       if(Data_Valid)
         begin
         //next_state = START;
         SER_EN = 1'b0;
         MUX_SEL = 2'b00;
         BUSY = 1'b1;
         end
       else
         begin
         //next_state = IDLE;
         SER_EN = 1'b0;
         MUX_SEL = 2'b11;
         BUSY = 1'b0;
         end
     end
     
     START: begin
       //next_state = DATA;
         SER_EN = 1'b1;
         MUX_SEL = 2'b01;
         BUSY = 1'b1;
     end
     
      DATA: begin 
if (ser_done)    
  begin   
    if (PAR_EN) 
      begin   
        //next_state = PAR;  
        SER_EN = 1'b0;
        MUX_SEL = 2'b10;
        BUSY = 1'b1;
               end   
      else 
       begin
       //next_state = STOP;
       SER_EN = 1'b0;
       MUX_SEL = 2'b11;
       BUSY = 1'b1;
              end
     end
    else 
      begin
      //next_state = DATA;
      SER_EN = 1'b1;
      MUX_SEL = 2'b01;
      BUSY = 1'b1;
           end
     end
     
      PAR: begin
        //next_state  = STOP;
        SER_EN = 1'b0;
        MUX_SEL = 2'b11;
        BUSY = 1'b1;
     end
     
      STOP: begin
        //next_state = IDLE;
        SER_EN = 1'b0;
        MUX_SEL = 2'b11;
        BUSY = 1'b0;
     end
     
      default: begin
        //next_state = IDLE;
        SER_EN = 1'b0;
        MUX_SEL = 2'b11;
        BUSY = 1'b0;
               end
   endcase
 end
 
endmodule
