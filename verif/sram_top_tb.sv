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
	.serial_in (int1.serial_in),
	.w_en (int1.w_en),
	.r_en (int1.r_en),
	.shift (int1.shift),
	.addr (int1.addr),
	.data_valid (int1.data_valid),
	.data_out (int1.data_out)
	);

	sram_top_intf int1(
	.clk (clk),
	.arst_n (arst_n)
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
		//initialize
		arst_n = 1'b1;
		int1.initialize();

		// write test
		int1.full_write();
		
		// read test
		int1.full_read ();

		#30;
		$finish;

	end
	
	initial begin
		$shm_open("shm_db");
		$shm_probe("ASMTR");
	end

	bind sram_top cov_sram cov1 (.*);

endmodule
