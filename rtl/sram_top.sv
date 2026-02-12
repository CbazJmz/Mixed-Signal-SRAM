module sram_top #(
	parameter ROWS=16, COLS=8)();

//   ________________________________
//  |              VDD   |    VSS    |
//  |--------------------------------|
//  |Typ Voltage|  1.5   |    0.0    |
//  |________________________________|

const real VDD =  1.5;
const real VSS =  0.0;
const real VTH =  0.8;

//Signals to serial input - parallel output
	logic clk;
	logic arst_n;
	logic w_en;
	logic r_en;
	logic serial_in;
	logic load;
	logic shift;
	logic [COLS-1:0]parallel_out;
	logic [COLS-1:0]data_out;
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
	.load (load),
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

	decoder #(
	.ROWS (ROWS)) decoder_wr(
	.row_sel (row_sel_wr),
	.row_wr (row_wr)
	);

	decoder #(
	.ROWS (ROWS)) decoder_rd(
	.row_sel (row_sel_rd),
	.row_wr (row_wr)
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
	genvar b;
	generate
		for(b=0;b<COLS;b++) begin: conv2
			assign data_out [a]= preout [a] >= VTH ? 1b'1 : 1'b0;
		end
	endgenerate

	endmodule