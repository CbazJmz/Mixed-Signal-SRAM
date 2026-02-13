module decoder #(
	parameter ROWS=16)(
	input  real row_sel [0:$clog2(ROWS)-1],
	output real row_out [0:ROWS-1]
);

//   ________________________________
//  |              VDD   |    VSS    |
//  |--------------------------------|
//  |Typ Voltage|  1.5   |    0.0    |
//  |________________________________|

const real VDD =  1.5;
const real VSS =  0.0;
const real VTH =  0.8;

//Real to logic convertion of selector
	logic [$clog2(ROWS)-1:0] row_selected;
	genvar s;
	generate
		for(s=0;s<($clog2(ROWS));s++) begin: SEL1
			assign row_selected [s] = row_sel [s] >= VTH ? 1'b1 : 1'b0;
		end
	endgenerate

//Onehot decoder
	logic [ROWS-1:0] row;
	assign row = '0 + (1'b1 << (row_selected));
	
//Logic to real convertion
	genvar o;
	generate
		for(o=0;o<ROWS;o++) begin: OUT1
			assign row_out [o] = row [o] == 1'b1 ? VDD : VSS;
		end
	endgenerate

endmodule
