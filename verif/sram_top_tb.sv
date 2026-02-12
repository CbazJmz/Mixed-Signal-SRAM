module sram_top_tb;

	parameter DATA_WIDTH = 1;
	parameter ADDR_WIDTH = 2;

	logic clk;
	logic arst_n;
	logic serial_in;
	logic shift;
	logic w_en;
	logic r_en;
	logic [ADDR_WIDTH-1:0] addr;
	logic [DATA_WIDTH-1:0] data_out;
	logic data_valid;

	sram_top #(
	.ROWS (ADDR_WIDTH),
	.COLS (DATA_WIDTH)) sram1(
	.clk (clk),
	.arst_n (arst_n),
	.serial_in (serial_in),
	.w_en (w_en),
	.r_en (r_en),
	.shift (shift),
	.addr (addr),
	.data_valid (data_valid),
	.data_out (data_out)
	);

	// Clock generation
	always #5 clk = ~clk;

	// Test procedure
	initial begin
		clk = 1'b0;
		arst_n = 1'b0;
		serial_in = 1'b0;
		shift = 1'b0;
		w_en = 1'b0;
		r_en = 1'b0;
		addr = 1'b0;

		// Reset
		#20;
		arst_n = 1'b1;

		// ----------------------
		// WRITE TEST
		// ----------------------
		addr = 1'b1;
		serial_in = 1'b1;
		addr = '0;
		shift = 1'b1;
		@(posedge clk);
		shift = 1'b0;

		@(posedge clk);
		w_en = 1'b1;
		@(posedge clk);
		w_en = 1'b0;

		// ----------------------
		// READ TEST
		// ----------------------
		@(posedge clk);
		r_en = 1'b1;
		@(posedge clk);
		r_en = 1'b0;

	end
	
	initial begin
		$shm_open("shm_db");
		$shm_probe("ASMTR");
	end

endmodule
