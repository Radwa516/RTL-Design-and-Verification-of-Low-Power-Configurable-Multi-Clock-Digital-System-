module ALU #(parameter Data_Width = 8) (
input wire [Data_Width-1:0]     A, B,
input wire [3:0]                ALU_FUN,
input wire                      CLK, RST,
input wire                      Enable,
output reg [(2*Data_Width)-1:0] alu_out,
output reg                      out_valid
//output reg        Arith_flag, Logic_flag, CMP_flag, Shift_flag
);

reg                      Carry;
reg [(2*Data_Width)-1:0] ALU_OUT;
reg                      OUT_valid;
//reg        arith_flag, logic_flag, cmp_flag, shift_flag;

//assign out_valid = (arith_flag || logic_flag || cmp_flag || shift_flag);

always@(posedge CLK or negedge RST)
 begin
   if(!RST)
     begin
      alu_out <= 'b0;
      out_valid <= 'b0;
      //Arith_flag <= 'b0;
      //Logic_flag<= 'b0;
      //CMP_flag <= 'b0; 
      //Shift_flag <= 'b0;
     end
   else
     begin
      alu_out <= ALU_OUT;
      out_valid <= OUT_valid;
      //Arith_flag <= arith_flag;
      //Logic_flag<= logic_flag;
      //CMP_flag <= cmp_flag; 
      //Shift_flag <= shift_flag;
     end
 end


always@(*)
 begin
  //arith_flag = 1'b0;
  //logic_flag = 1'b0;
  //cmp_flag = 1'b0; 
  //shift_flag = 1'b0;
if (Enable)
  begin  
   case (ALU_FUN)
   4'b0000 : begin
   {Carry, ALU_OUT} = A + B;
   //arith_flag = 1'b1;
   OUT_valid = 1'b1;
              end
   
   4'b0001 : begin
   ALU_OUT = A - B;
   //arith_flag = 1'b1;
   OUT_valid = 1'b1;
              end
              
   4'b0010 : begin
   ALU_OUT = A * B;
   //arith_flag = 1'b1;
   OUT_valid = 1'b1;
              end
              
   4'b0011 : begin
   ALU_OUT = A / B;
   //arith_flag = 1'b1;
   OUT_valid = 1'b1;
              end
              
   4'b0100 : begin
   ALU_OUT = A & B;
   //logic_flag = 1'b1;
   OUT_valid = 1'b1;
              end
              
   4'b0101 : begin
   ALU_OUT = A | B;
   //logic_flag = 1'b1;
   OUT_valid = 1'b1;
              end
              
   4'b0110 : begin
   ALU_OUT = ~(A & B);
   //logic_flag = 1'b1;
   OUT_valid = 1'b1;
 
              end
              
   4'b0111 : begin
   ALU_OUT = ~(A | B);
   //logic_flag = 1'b1;
   OUT_valid = 1'b1;
              end
              
   4'b1000 : begin
   ALU_OUT = A ^ B;
  // logic_flag = 1'b1;
  OUT_valid = 1'b1;
              end
              
   4'b1001 : begin
   ALU_OUT = A ~^ B;
   //logic_flag = 1'b1;
   OUT_valid = 1'b1;
              end
              
   4'b1010 : begin
   ALU_OUT = (A==B)?('b1):('b0);
   //cmp_flag = 1'b1;
   OUT_valid = 1'b1;
              end
              
   4'b1011 : begin
   ALU_OUT = (A>B)?('b10):('b0);
   //cmp_flag = 1'b1;
   OUT_valid = 1'b1; 
              end
              
   4'b1100 : begin
   ALU_OUT = (A<B)?('b11):('b0);
   //cmp_flag = 1'b1;
   OUT_valid = 1'b1;
              end
              
   4'b1101 : begin
   ALU_OUT = A >> 1;
   //shift_flag = 1'b1;
   OUT_valid = 1'b1;
              end
              
   4'b1110 : begin
   ALU_OUT = A << 1;
   //shift_flag = 1'b1;
   OUT_valid = 1'b1;
              end
              
   default : begin
   ALU_OUT = 'b0;
   OUT_valid = 1'b0;
   //arith_flag = 1'b0;
   //logic_flag = 1'b0;
   //cmp_flag = 1'b0; 
   //shift_flag = 1'b0;
              end
   endcase
 end 
else
  begin
    ALU_OUT = 'b0;
    OUT_valid = 1'b0;
 end
end
  
endmodule
