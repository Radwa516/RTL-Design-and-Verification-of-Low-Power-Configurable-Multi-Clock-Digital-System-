module Reg_File #(parameter Mem_Width = 8,
                  parameter Mem_Depth = 16,
                  parameter Addr_Width = 4) (
input wire  [Addr_Width-1:0]  Address,
input wire                    WrEn, RdEn,
input wire                    CLK, RST,
input wire  [Mem_Width-1:0]   WrData,
output reg  [Mem_Width-1:0]   RdData,
output reg                    RdData_Valid,
output wire [Mem_Width-1:0]   REG0,
output wire [Mem_Width-1:0]   REG1,
output wire [Mem_Width-1:0]   REG2,
output wire [Mem_Width-1:0]   REG3
);

integer i;
reg [Mem_Width-1:0] Reg_File [Mem_Depth-1:0];  //2D Array

/////////////////for writing/////////////////////// 
always@(posedge CLK or negedge RST)
 begin
   if (!RST)
     begin
       //RdData <= 'b0;
       for (i=0; i<Mem_Depth; i=i+1)
         begin
           if (i==2)
             begin
               Reg_File[2] <= 'h41; //"0100 0001" 1 --> EN            
               end                  // 0-------> even par
           else if (i==3)
             Reg_File[3] <= 'd01;  //"1" after mux will be 32
           else
            Reg_File[i] <= 'b0;   
         end
     end
   else 
     begin
       if (WrEn && !RdEn)
         begin
           Reg_File[Address] <= WrData;
           //RdData <= 'b0;
         end
         /*
         else if (!WrEn && RdEn)
         begin
           RdData <= Reg_File[Address];
         end
           else if (WrEn && RdEn)
         begin
           RdData <= 'b0;
         end*/
     end  
 end  

///////////////////////for reading/////////////////////// 
always@(posedge CLK or negedge RST)
 begin
   if (!RST)
     begin
       RdData <= 'b0; 
       RdData_Valid <= 'b0;  
     end
   else 
     begin
       if (!WrEn && RdEn)
         begin
           RdData <= Reg_File[Address];
           RdData_Valid <= 'b1;
         end
       else
         begin
           RdData <= RdData;
           RdData_Valid <= 'b0;
         end
     end  
 end 
 
//////////////////////for REGs//////////////////////////
/*
always@(posedge CLK or negedge RST) 
  begin
     REG0 <= REG0; 
     REG1 <= REG1;
     REG2 <= REG2;
     REG3 <= REG3;
        case (Address)
          'd0: REG0 <= Reg_File[0];
          'd1: REG1 <= Reg_File[1];
          'd2: REG2 <= Reg_File[2];
          'd3: REG3 <= Reg_File[3];
          default: REG0 <= REG0;
        endcase 
  end 
*/
assign REG0 = Reg_File[0];
assign REG1 = Reg_File[1];
assign REG2 = Reg_File[2];
assign REG3 = Reg_File[3]; 
 
endmodule                                
