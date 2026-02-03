module cell_array #(
   	parameter ROWS=16, COLS=8)(
   	input  real row_wr [0:ROWS-1],
	input  real row_rd [0:ROWS-1],
   	input  real bl_wr [0:COLS-1],
   	input  real blb_wr [0:COLS-1],
	output  logic [COLS-1:0]bl_rd,
   	output  logic [COLS-1:0]blb_rd
);

//   ________________________________
//  |              VDD   |    VSS    |
//  |--------------------------------|
//  |Typ Voltage|  1.5   |    0.0    |
//  |________________________________|

const real VDD =  1.5;
const real VSS =  0.0;
const real VTH =  0.8; 

    //Rows and columns variables
    genvar r,c;
    //Generate memory array
    generate
        for(r=0;r<ROWS;r++) begin: ROW
            for(c=0;c<COLS;c++) begin: COL
                sram_cell cell1(
                	.row_wr (row_wr[r]),
			.row_rd (row_rd[r]),
                    	.bl_wr (bl_wr[c]),
                    	.blb_wr(blb_wr[c]),
			.bl_rd (bl_rd[c]),
                   	.blb_rd(blb_rd[c])
                );
            end
        end
    endgenerate
endmodule
