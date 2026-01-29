module r_sram_cell_tb();
	
	logic row_wr;
	logic row_rd;
    real bl_wr;
    real blb_wr;
	real bl_rd;
	real blb_rd;

//   ________________________________
//  |              VDD   |    VSS    |
//  |--------------------------------|
//  |Typ Voltage|  1.5   |    0.0    |
//  |________________________________|

const real VDD =  1.5;
const real VSS =  0.0;
const real VTH =  0.8; 
	
    sram_cell cell1(
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

