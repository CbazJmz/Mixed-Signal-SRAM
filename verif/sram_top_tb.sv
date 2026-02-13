module sram_top_tb;

	logic clk;
	logic arst_n;
	logic serial_in;
	logic shift;
	logic w_en;
	logic r_en;
	logic [$clog2(ROWS)-1:0]addr;
	logic data_valid;
	logic [COLS-1:0]data_out;

	sram_top sram1(
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

	// Task: send serial word
	task send_serial_word(input logic [COLS-1:0] word);
		integer i;
		begin
			for (i = COLS-1; i >= 0; i--) begin
				serial_in = word[i];
				shift  = 1'b1;
				repeat (2) @(posedge clk);
			end
			shift = 1'b0;
		end
	endtask

	// Test procedure
	initial begin
		clk = 1'b0;
		arst_n = 1'b0;
		serial_in = 1'b0;
		shift = 1'b0;
		w_en = 1'b0;
		r_en = 1'b0;
		addr = '0;

		// Reset
		#20;
		arst_n = 1'b1;

		// ----------------------
		// WRITE TEST
		// ----------------------
		addr = 1'b1;
		
		send_serial_word(8'b10011101);

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

		#30;
		$finish;

	end
	
	initial begin
		$shm_open("shm_db");
		$shm_probe("ASMTR");
	end

endmodule
