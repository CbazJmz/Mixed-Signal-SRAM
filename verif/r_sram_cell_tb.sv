module r_sram_cell_tb #(
    parameter ROWS=1, COLS=1)();
	
	real row_wr [0:ROWS-1];
	real row_rd [0:ROWS-1];
    real bl_wr [0:COLS-1];
    real blb_wr [0:COLS-1];
	real bl_rd [0:COLS-1];
	real blb_rd [0:COLS-1];

//   ________________________________
//  |              VDD   |    VSS    |
//  |--------------------------------|
//  |Typ Voltage|  1.5   |    0.0    |
//  |________________________________|

const real VDD =  1.5;
const real VSS =  0.0;
const real VTH =  0.8; 
	
    cell_array cell1 #(
    .ROWS (ROWS),
	.COLS (COLS))(
    .row_wr (row_wr),
	.row_rd (row_rd),
    .bl_wr (bl_wr),
    .blb_wr(blb_wr),
	.bl_rd (bl_rd),
    .blb_rd(blb_rd)
    );
	
    initial begin
	
		row_wr = 1'b0;
		row_rd = 1'b0;
		bl_wr = 0;
		blb_wr = 0;
		
		#1ns;
		
		//Write 1 operation
		
		bl_wr = VDD;
		blb_wr = VSS;
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
		
		bl_wr = VSS;
		blb_wr = VDD;
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

