module serializer (
input wire [7:0] P_Data, 
input wire       ser_en, Data_Valid,
input wire       CLK, RST,
output reg       ser_data,
output wire      ser_done,
output reg [7:0] store
);

reg [3:0] Counter;
reg [7:0] temp [1:0];
integer i;

always@(posedge CLK or negedge  RST)
 begin
   if (!RST)
     begin
     temp[1] = 8'b0;
     store = 8'b0;
     temp[0] = 8'b0;
     end
 else if (ser_done || Data_Valid  || ser_en)
     begin
     temp[1] = P_Data;
     store = temp[0];
     temp[0] = temp[0];
     end
   else
     begin
     temp[0] = P_Data;
     temp[1] = temp[1];
     store = temp[0];
     end
 end
 
 
// comp ser_data 
always@(*)
  begin
   if (!ser_done)
      ser_data = store[Counter];
     else if (ser_done)
      ser_data = store[7];
    else 
      ser_data = 1'b1;
 end

// seq counter 
always@(posedge CLK, negedge RST)
  begin
    if (!RST)
        Counter <= 4'b0;

  else if (ser_en)
      Counter <= Counter + 4'b001;
      
    else
      Counter <= 4'b0;
  end

assign ser_done = (Counter == 4'b0111);
 
endmodule
