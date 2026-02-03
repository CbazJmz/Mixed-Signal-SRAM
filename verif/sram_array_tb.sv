module sram_array_tb #(
    parameter ROWS=2, COLS=8)();
	
	logic [COLS-1:0] data;
	real data_in [0:COLS-1];
	real preout [0:COLS-1];
	real row_wr [0:ROWS-1];
	real row_rd [0:ROWS-1];
	real bl_wr [0:COLS-1];
	real blb_wr [0:COLS-1];
	logic [COLS-1:0] bl_rd;
	logic [COLS-1:0] blb_rd;

//   ________________________________
//  |              VDD   |    VSS    |
//  |--------------------------------|
//  |Typ Voltage|  1.5   |    0.0    |
//  |________________________________|

const real VDD =  1.5;
const real VSS =  0.0;
const real VTH =  0.8; 
	
	write_driver #(
		.COLS (COLS)) wr1(
    	.data_in (data_in),
		.bl_wr (bl_wr),
    	.blb_wr(blb_wr)
    );
	
    cell_array #(
		.ROWS (ROWS),
		.COLS (COLS)) cell1(
    	.row_wr (row_wr),
		.row_rd (row_rd),
    	.bl_wr (bl_wr),
    	.blb_wr(blb_wr),
		.bl_rd (bl_rd),
    	.blb_rd(blb_rd)
    );
	
	sense_amp #(
		.COLS (COLS)) sa1(
    	.preout (preout),
		.bl_rd (bl_rd),
    	.blb_rd(blb_rd)
    );

	genvar c;
	for (c=0;c<COLS;c++) begin: COL
	    assign data_in [c] = data [c] ? VDD : VSS;
	end
	
    initial begin
	
		row_wr [0]= VSS;
		row_rd [0]= VSS;
		#1ns;
		
		//Write 1 operation
		data = 8'b10110111;
		row_wr [0]= VDD;
		#10ns;
		row_wr [0]= VSS;
		#10ns;
		
		//Read operation
		
		row_rd [0]= VDD;
		#10ns;
		row_rd [0]= VSS;
		#10ns;

        $finish;
    end

    initial begin
	    $shm_open("shm_db");
	    $shm_probe("ASMTR");
    end

endmodule

