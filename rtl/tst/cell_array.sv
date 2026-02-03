module cell_array #(
    parameter ROWS=16, COLS=8)(
    input  real row_wr [0:ROWS-1],
	input  real row_rd [0:ROWS-1],
    input  real bl_wr [0:COLS-1],
    input  real blb_wr [0:COLS-1],
	output  real bl_rd [0:COLS-1],
    output  real blb_rd [0:COLS-1]
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
                    .r_row_wr (row_wr[r]),
					.r_row_rd (row_rd[r]),
                    .r_bl_wr (bl_wr[c]),
                    .r_blb_wr(blb_wr[c]),
					.r_bl_rd (bl_rd[c]),
                    .r_blb_rd(blb_rd[c])
                );
            end
        end
    endgenerate
endmodule
