module cell_array #(
	parameter ROWS=16, COLS=8)(
	input  real row_wr [0:ROWS-1],
	input  real bl_wr [0:COLS-1],
	input  real blb_wr [0:COLS-1],
	output  real bl_rd [0:ROWS-1][0:COLS-1],
	output  real blb_rd [0:ROWS-1][0:COLS-1]
);

//   ________________________________
//  |              VDD   |    VSS    |
//  |--------------------------------|
//  |Typ Voltage|  1.5   |    0.0    |
//  |________________________________|

const real VDD =  1.5;
const real VSS =  0.0;
const real VTH =  0.8;

	logic [ROWS-1:0] l_wr;
	genvar a;
	generate
		for (a=0;a<ROWS;a++) begin: LASSIGN
			assign l_wr [a] = row_wr [a] >= VTH ? 1'b1 : 1'b0;
		end
	endgenerate

	//Rows and columns variables
	genvar r,c;
	//Generate memory array
	generate
		for(c=0;c<COLS;c++) begin: COL
			for(r=0;r<ROWS;r++) begin: ROW
				sram_cell cell1(
				.row_wr (row_wr[r]),
				.bl_wr (bl_wr[c]),
				.blb_wr (blb_wr[c]),
				.bl_rd (bl_rd_array[r][c]),
				.blb_rd (blb_rd_array[r][c])
				);
			end
		end
	endgenerate

endmodule
