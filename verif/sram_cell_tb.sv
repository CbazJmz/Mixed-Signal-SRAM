module sram_cell_tb#(
    parameter COLS=1)();
	
	logic data_in;
	logic rd;
	logic wr;
	logic row_wr;
	logic row_rd;
	logic preout;

	real bl_col;
	real blb_col;
	real bl_wr;
	real blb_wr;
	real bl_rd;
	real blb_rd;
	real obl_col;
	real oblb_col;
	
    sram_cell cell1(
    .row_wr (row_wr),
    .bl_col (bl_col),
    .blb_col(blb_col),
	.obl_col (obl_col),
    .oblb_col(oblb_col)
    );
	
	write_driver #(.COLS (COLS)) writed1 (
	.data_in (data_in),
	.bl_wr (bl_wr),
	.blb_wr (blb_wr)
	);
	
	sense_amp #(.COLS (COLS)) amp1 (
	.bl_col (obl_col),
	.blb_col (oblb_col),
	.preout (preout)
	);
	
	// Multiplexer for read or write operation
	assign blb_col = wr ? blb_rd : blb_wr;
	assign bl_col = wr ? bl_rd : bl_wr;

    // Initial procedural block that is executed at t=0
    // This starts a concurrent process
    initial begin
	
		data_in = 1'b0;
		wr = 1'b0;
		row_wr = 1'b0;
		
		#10ns;
		
		//Write 1 operation
		
		data_in = 1'b1;
		wr = 1'b0;
		#10ns;
		row_wr = 1'b1;
		#10ns;
		row_wr = 1'b0;
		#10ns;
		
		//Read operation
		
		wr = 1'b1;
		#10ns;
		row_wr = 1'b1;
		#10ns;
		row_wr = 1'b0;
		#10ns;
		
		//Write 0 operation
		
		data_in = 1'b0;
		wr = 1'b0;
		#10ns;
		row_wr = 1'b1;
		#10ns;
		row_wr = 1'b0;
		#10ns;
		
		//Read operation
		
		wr = 1'b1;
		#10ns;
		row_wr = 1'b1;
		#10ns;
		row_wr = 1'b0;
		#10ns;

        $finish;
    end

    initial begin
	    $shm_open("shm_db");
	    $shm_probe("ASMTR");
    end

endmodule

