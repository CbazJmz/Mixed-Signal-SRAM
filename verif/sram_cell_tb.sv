module sram_cell_tb#(
    parameter COLS=1)();
	
	logic data_in;
	logic row_wr;
	logic row_rd;
	logic preout;
	logic bl_wr;
	logic blb_wr;
	
	real bl_rd;
	real blb_rd;

typedef enum logic [1:0] {
    DATA_TRUE,      // True
    DATA_FALSE,     // False
    INDET       	// Indeterminated
} state_data;
	
// As stated in Table 1 of  ERS, the VDD, and VSS pads have the following specifications
//   ________________________________
//  |             TRUE   |   FALSE   |
//  |--------------------------------|
//  |Min Voltage|  1.3   |   -0.5    |
//  |Typ Voltage|  1.5   |    0.0    |
//  |Max Voltage|  2.2   |    0.7    |
//  |________________________________|
	
	const real TRUE_MIN =  1.3;
	const real TRUE_MAX =  2.2;
	const real FALSE_MIN = -0.5;
	const real FALSE_MAX =  0.7;
	
    sram_cell cell1(
    .row_wr (row_wr),
	.row_rd (row_rd),
    .bl_wr (bl_wr),
    .blb_wr(blb_wr),
	.bl_rd (bl_rd),
    .blb_rd(blb_rd)
    );
	
	write_driver writed1 (
	.data_in (data_in),
	.bl_wr (bl_wr),
	.blb_wr (blb_wr)
	);
	
	sense_amp amp1 (
	.bl_rd (bl_rd),
	.blb_rd (blb_rd),
	.preout (preout)
	);
	
	state_data curr_data_state;
	
	always_comb begin
		if(preout>TRUE_MIN & preout<TRUE_MAX)
			curr_data_state = DATA_TRUE;
		else if(preout>FALSE_MIN & preout<FALSE_MAX)
			curr_data_state = DATA_FALSE;
		else
			curr_data_state = INDET;
	end	
	
    // Initial procedural block that is executed at t=0
    // This starts a concurrent process
    initial begin
	
		data_in = 1'b0;
		row_wr = 1'b0;
		row_rd = 1'b0;
		
		#10ns;
		
		//Write 1 operation
		
		data_in = 1'b1;
		#10ns;
		row_wr = 1'b1;
		#10ns;
		row_wr = 1'b0;
		#10ns;
		
		//Read operation
		
		row_rd = 1'b1;
		#10ns;
		row_rd = 1'b0;
		#10ns;
		
		//Write 0 operation
		
		data_in = 1'b0;
		#10ns;
		row_wr = 1'b1;
		#10ns;
		row_wr = 1'b0;
		#10ns;
		
		//Read operation
		
		row_rd = 1'b1;
		#10ns;
		row_rd = 1'b0;
		#10ns;

        $finish;
    end

    initial begin
	    $shm_open("shm_db");
	    $shm_probe("ASMTR");
    end

endmodule

