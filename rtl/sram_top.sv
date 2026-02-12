module sram_top #(
	parameter ROWS=16, COLS=8)(
	input logic clk,
	input logic arst_n,
	input logic serial_in,
	input logic w_en,
	input logic r_en,
	input logic shift,
	input logic [ROWS-1:0]addr,
	output logic data_valid,
	output logic [COLS-1:0]data_out
	);

//   ________________________________
//  |              VDD   |    VSS    |
//  |--------------------------------|
//  |Typ Voltage|  1.5   |    0.0    |
//  |________________________________|

const real VDD =  1.5;
const real VSS =  0.0;
const real VTH =  0.8;

//Signals to serial input - parallel output
	logic [COLS-1:0]parallel_out;
//Signals to write circuit
	real data_in [0:COLS-1];
//Signals to memory array
	real row_wr [0:ROWS-1];
	real bl_wr [0:COLS-1];
	real blb_wr [0:COLS-1];
	real bl_rd [0:ROWS-1][0:COLS-1];
	real blb_rd [0:ROWS-1][0:COLS-1];
//Signals to row decoder / writer
	real row_sel_wr [0:$clog2(ROWS)-1];
//Signals to sense amplificators
	real row_rd [0:ROWS-1];
	real preout [0:COLS-1];
//Signals to row decoder / reader
	real row_sel_rd [0:$clog2(ROWS)-1];

	sipo#(
	.COLS (COLS)) sipo1(
	.clk (clk),
	.arst_n (arst_n),
	.serial_in (serial_in),
	.load (w_en),
	.shift (shift),
	.parallel_out (parallel_out)
	);

//Digital to analog converter SIPO
	genvar a;
	generate
		for(a=0;a<COLS;a++) begin: conv1
			assign data_in [a]= parallel_out [a] == 1'b1 ? VDD : VSS;
		end
	endgenerate

	write_driver #(
	.COLS (COLS)) writer1(
	.data_in (data_in),
	.bl_wr (bl_wr),
	.blb_wr(blb_wr)
	);

	cell_array #(
	.ROWS (ROWS),
	.COLS (COLS)) cell1(
	.row_wr (row_wr),
	.bl_wr (bl_wr),
	.blb_wr(blb_wr),
	.bl_rd (bl_rd),
	.blb_rd(blb_rd)
	);

//Digital to analog converter row_sel_wr
	genvar b;
	generate
		for(b=0;b<COLS;b++) begin: conv2
			assign row_sel_wr [b]= addr [b] == 1'b1 ? VDD : VSS;
		end
	endgenerate

	decoder #(
	.ROWS (ROWS)) decoder_wr(
	.row_sel (row_sel_wr),
	.row_out (row_wr)
	);

	genvar c;
	generate
		for(c=0;c<COLS;c++) begin: conv3
			assign row_sel_rd [c]= addr [c] == 1'b1 ? VDD : VSS;
		end
	endgenerate

	decoder #(
	.ROWS (ROWS)) decoder_rd(
	.row_sel (row_sel_rd),
	.row_out (row_rd)
	);

	sense_amp #(
	.ROWS (ROWS),
	.COLS (COLS)) lines_comp1(
	.row_rd (row_rd),
	.bl_rd (bl_rd),
	.blb_rd (blb_rd),
	.preout (preout)
	);

//Analog to digital converter output
	genvar d;
	generate
		for(d=0;d<COLS;d++) begin: conv4
			assign data_out [d]= rd_en == 1'b1 ? (preout [d] >= VTH ? 1'b1 : 1'b0) : VSS;
		end
	endgenerate

	assign data_valid = r_en == 1'b1 ? 1'b1 : 1'b0;

	endmodule
