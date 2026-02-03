module sram_cell (
    input  real r_row_wr,
	input  real r_row_rd,
    input  real r_bl_wr,
    input  real r_blb_wr,
	output real r_bl_rd,
	output real r_blb_rd
);
    
//   ________________________________
//  |              VDD   |    VSS    |
//  |--------------------------------|
//  |Typ Voltage|  1.5   |    0.0    |
//  |________________________________|

const real VDD =  1.5;
const real VSS =  0.0;
const real VTH =  0.8; 	
	
	//Variables
	logic row_rd;
	logic row_wr;
	logic bl_wr;
	logic blb_wr;
	logic bl_rd;
	logic blb_rd;
	
	// NMOS and NOT Gates nodes
    logic inv1;
    logic inv2;
	
	//Logic and real comparators
	assign row_rd = r_row_rd >= VTH ? 1'b1 : 1'b0;
	assign row_wr = r_row_wr >= VTH ? 1'b1 : 1'b0;
	assign bl_wr = r_bl_wr >= VTH ? 1'b1 : 1'b0;
	assign blb_wr = r_blb_wr >= VTH ? 1'b1 : 1'b0;
	assign r_bl_rd = bl_rd ? VDD : VSS;
	assign r_blb_rd = blb_rd ? VDD : VSS;	
	
    // Memory cell structure
    nmos nmos1(inv1,bl_wr,row_wr);
    nmos nmos2(blb_wr,inv2,row_wr);
	nmos nmos3(inv1,bl_rd,row_rd);
    nmos nmos4(blb_rd,inv2,row_rd);
    not not1(inv2,inv1);
    not not2(inv1,inv2);
	
endmodule
