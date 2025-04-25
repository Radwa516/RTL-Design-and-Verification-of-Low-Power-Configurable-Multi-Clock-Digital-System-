module MUX (
//input wire       Data_Valid,
input wire       RST,
input wire       ser_data, par_bit,
input wire [1:0] mux_sel,
output reg       TX_OUT
);

wire start_bit, stop_bit;

assign start_bit = 1'b0;
assign stop_bit = 1'b1;

always@(*)
 begin
   if (!RST)
     begin
     TX_OUT <= 1'b1;
     end
   else
     begin
       case (mux_sel)
         2'b00: begin
            TX_OUT <= start_bit;
             end
             
        2'b01: begin
            TX_OUT <= ser_data;
             end
             
        2'b10: begin
            TX_OUT <= par_bit;
             end
             
        2'b11: begin
            TX_OUT <= stop_bit;
             end 
        endcase  
      end  
    end
endmodule

