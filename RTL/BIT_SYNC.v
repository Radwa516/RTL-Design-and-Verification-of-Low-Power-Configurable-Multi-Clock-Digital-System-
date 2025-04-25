module BIT_SYNC #(parameter NUM_STAGES = 5, parameter BUS_WIDTH = 4) (
	input wire [BUS_WIDTH-1:0] ASYNC,
	input wire                 CLK,
	input wire                 RST,
	output reg [BUS_WIDTH-1:0] SYNC
);

	reg [NUM_STAGES-1:0] Q [BUS_WIDTH-1:0]; 
	integer i, n;

	reg [BUS_WIDTH-1:0] bridge;

	always@(posedge RST or negedge CLK)
 		begin
   			if (!RST)
     				begin
       					bridge <= 0;
     				end
   			else
    				begin
					bridge <= ASYNC;
     				end
 		end

	always@(posedge RST or negedge CLK)
 		begin
   			if (!RST)
     				begin
       					SYNC <= 0;
     				end
   			else
    				begin
					SYNC <= bridge;
     				end
 		end

endmodule
