interface sram_top_intf (
	input logic clk,
	input logic arst_n
);

	logic serial_in;
	logic shift;
	logic w_en;
	logic r_en;
	logic [$clog2(ROWS)-1:0]addr;
	logic data_valid;
	logic [COLS-1:0]data_out;

	task automatic initialize();
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
	endtask

	// Task: send serial word
	task automatic send_serial_word(input logic [COLS-1:0] word);
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

	task automatic full_write(input logic [COLS-1:0] word1);
		integer i;
		integer j;
		begin
			for (i = 0; i < $clog2(ROWS); i++) begin
				addr = i;
				send_serial_word(std::randomize(word1));
				@(posedge clk);
				w_en = 1'b1;
				@(posedge clk);
				w_en = 1'b0;
			end
		end
	endtask

	task automatic full_read();
		integer i;
		integer j;
		begin
			for (i = 0; i < $clog2(ROWS); i++) begin
				addr = i;
				@(posedge clk);
				r_en = 1'b1;
				@(posedge clk);
				r_en = 1'b0;
			end
		end
	endtask

	task automatic wr_or_rd_random(input logic [COLS-1:0] random_data, input logic [$clog2(ROWS)-1:0] addr1);
		if($urandom_range(0,1) == 1) begin
			addr = addr1;
			send_serial_word(random_data);
			@(posedge clk);
			w_en = 1'b1;
			@(posedge clk);
			w_en = 1'b0;
		end else begin
			addr = addr1;
			@(posedge clk);
			r_en = 1'b1;
			@(posedge clk);
			r_en = 1'b0;
		end
	endtask

endinterface
