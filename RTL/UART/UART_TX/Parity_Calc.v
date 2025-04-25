module Parity_Calc (
	input wire [7:0] store,
	input wire       PAR_TYP, busy,
	output reg       par_bit
);

	always@(*)
		begin
					if (PAR_TYP == 0)
						begin
							par_bit <= (^store);
						end
					else
						begin
							par_bit <= ~(^store);
						end
		end

endmodule
