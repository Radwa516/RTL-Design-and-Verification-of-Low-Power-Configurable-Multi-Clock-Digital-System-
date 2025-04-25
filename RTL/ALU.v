module ALU #(parameter Data_Width = 8) (
	input wire [Data_Width-1:0]     A, B,
	input wire [3:0]                ALU_FUN,
	input wire                      CLK, RST,
	input wire                      Enable,
	output reg [(2*Data_Width)-1:0] alu_out,
	output reg                      out_valid
);

	reg                      Carry;
	reg [(2*Data_Width)-1:0] ALU_OUT;
	reg                      OUT_valid;

	localparam 	ADD 	= 4'h0,
			SUB 	= 4'h1,
			MUL 	= 4'h2,
			DIV 	= 4'h3,
			AND 	= 4'h4,
			OR  	= 4'h5,
			NAND 	= 4'h6,
			NOR 	= 4'h7,
			XOR 	= 4'h8,
			XNOR 	= 4'h9,
			EQUAL	= 4'hA,
			GREATER	= 4'hB,
			LESS	= 4'hC,
			SHIFT_R	= 4'hD,
			SHIFT_L	= 4'hE;
				
			

	always@(posedge CLK or negedge RST)
 		begin
   			if(!RST)
     				begin
      					alu_out <= 'b0;
      					out_valid <= 'b0;
     				end
   			else
     				begin
      					alu_out <= ALU_OUT;
      					out_valid <= OUT_valid;
     				end
 		end


	always@(*)
 		begin
			if (Enable)
  				begin  
   					case (ALU_FUN)
   					ADD 	: begin //FUNC 0
							{Carry, ALU_OUT} = A + B;
							OUT_valid = 1'b1;
              				end
   
   					SUB 	: begin //FUNC 1
							ALU_OUT = A - B;
							OUT_valid = 1'b1;
              				end
              
   					MUL 	: begin //FUNC 2
							ALU_OUT = A * B;
							OUT_valid = 1'b1;
              				end
              
   					DIV 	: begin  //FUNC 3
							ALU_OUT = A / B;
							OUT_valid = 1'b1;
             				end
              
   					AND 	: begin //FUNC 4
							ALU_OUT = A & B;
							OUT_valid = 1'b1;
              				end
              
   					OR 		: begin //FUNC 5
							ALU_OUT = A | B;
							OUT_valid = 1'b1;
              				end
              
   					NAND 	: begin //FUNC 6
							ALU_OUT = ~(A & B);
							OUT_valid = 1'b1;
             				end
              
   					NOR 	: begin //FUNC 7
							ALU_OUT = ~(A | B);
							OUT_valid = 1'b1;
              						end
              
   					XOR 	: begin //FUNC 8
							ALU_OUT = A ^ B;
							OUT_valid = 1'b1;
              				end
              
   					XNOR 	: begin //FUNC 9
							ALU_OUT = A ~^ B;
							OUT_valid = 1'b1;
              				end
              
   					EQUAL 	: begin //FUNC A
							ALU_OUT = (A==B)?('b1):('b0);
							OUT_valid = 1'b1;
              				end
              
   					GREATER	: begin //FUNC B
							ALU_OUT = (A>B)?('b10):('b0);
							OUT_valid = 1'b1; 
              				end
              
   					LESS 	: begin //FUNC C
							ALU_OUT = (A<B)?('b11):('b0);
							OUT_valid = 1'b1;
              				end
              
   					SHIFT_R : begin //FUNC D
							ALU_OUT = A >> 1;
							OUT_valid = 1'b1;
              				end
              
   					SHIFT_L	: begin //FUNC E
							ALU_OUT = A << 1;
							OUT_valid = 1'b1;
              				end
              
   					default : begin
							ALU_OUT = 'b0;
							OUT_valid = 1'b0;
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
