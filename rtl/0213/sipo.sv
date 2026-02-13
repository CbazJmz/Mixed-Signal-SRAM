module sipo(
	input logic clk,
	input logic arst_n,
	input logic serial_in,
	input logic load,
	input logic shift,
	output logic [COLS-1:0] parallel_out
	);

	logic [COLS-1:0] shift_reg;

	always_ff@(posedge clk, negedge arst_n) begin
		if(!arst_n) begin
			shift_reg <= '0;
		end else begin
			if(shift)
				shift_reg <= {shift_reg, serial_in};
			else if(load)
				parallel_out <= shift_reg;
		end
	end

endmodule