module sram_top_tb;

	logic clk;
	logic arst_n;
	logic serial_in;
	logic shift;
	logic load;
	logic w_en;
	logic r_en;
	logic [$clog2(ROWS)-1:0]addr;
	logic data_valid;
	logic [COLS-1:0]data_out;
	
	logic [COLS-1:0] parallel_sipo;
	logic [ROWS-1:0] ref_mem [0:COLS-1];

	always @(posedge clk) begin
		if (arst_n && int1.w_en) begin
			ref_mem[int1.addr] <= parallel_sipo;
		end
	end
	
	property memory_correctness;
	@(posedge clk)
	disable iff (!arst_n)
	(int1.r_en && int1.data_valid) |-> (int1.data_out == ref_mem[int1.addr]);

	endproperty

	assert property(memory_correctness);

	
	sipo s1(
	.clk (clk),
	.arst_n (arst_n),
	.serial_in (int1.serial_in),
	.load (int1.load),
	.shift (int1.shift),
	.parallel_out (parallel_sipo)
	);


	sram_top sram1(
	.clk (clk),
	.arst_n (arst_n),
	.serial_in (int1.serial_in),
	.load (int1.load),
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

	// Test procedure
	initial begin
		//initialize
		clk = 1'b0;
		arst_n = 1'b0;
		int1.initialize();

		// Reset
		#20;
		arst_n = 1'b1;

		// write test
		#20;
		int1.full_write_combs();

		// read test
		#20;
		int1.full_read ();
		
		// wr rd test
		#20;
		int1.full_wrrd_combs();

		// random test
		#20;
		int1.wr_or_rd_random('0);

	end
	
	initial begin
		#235ms;
		$finish;
	end

	initial begin
		$shm_open("shm_db");
		$shm_probe("ASMTR");
	end

	bind sram_top cov_sram cov1 (.*);

endmodule
