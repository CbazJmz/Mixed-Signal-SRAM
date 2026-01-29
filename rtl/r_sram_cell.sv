module sram_cell (
    input  logic row_wr,
	input  logic row_rd,
    input  real bl_wr,
    input  real blb_wr,
	output real bl_rd,
	output real blb_rd
);

//   ________________________________
//  |              VDD   |    VSS    |
//  |--------------------------------|
//  |Typ Voltage|  1.5   |    0.0    |
//  |________________________________|

const real VDD =  1.5;
const real VSS =  0.0;
const real VTH =  0.8; 

    // NMOS and NOT Gates nodes
    real r_inv1;
    real r_inv2;
	
	logic inv1;
	logic inv2;
    // Memory cell structure
    nmosfet nmos1(
	.vd (bl_wr),
	.vg (row_wr),
	.vs (r_inv1)
	);
	
	nmosfet nmos2(
	.vd (blb_wr),
	.vg (row_wr),
	.vs (r_inv2)
	);

	always_comb begin
		if(r_inv1<VTH)
			inv1 = 1'b0;
		else if(r_inv1>=VTH)
			inv1 = 1'b1;
		else
			inv1 = inv1;
	end
	
	always_comb begin
		if(r_inv2<VTH)
			inv2 = 1'b0;
		else if(r_inv2>=VTH)
			inv2 = 1'b1;
		else
			inv2 = inv2;
	end

    not not1(inv2,inv1);
    not not2(inv1,inv2);
	nmos nmos3(inv1,bl_rd,row_rd);
    nmos nmos4(blb_rd,inv2,row_rd);
	
endmodule
