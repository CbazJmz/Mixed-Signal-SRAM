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
    real r_inv1_1;
    real r_inv2_1;
	real r_inv1_2;
    real r_inv2_2;
	
	logic inv1;
	logic inv2;
    // Memory cell structure
    nmosfet nmos1(
	.vd (bl_wr),
	.vg (row_wr),
	.vs (r_inv1_1)
	);
	
	nmosfet nmos2(
	.vd (blb_wr),
	.vg (row_wr),
	.vs (r_inv2_1)
	);

	always_comb begin
		if(r_inv1_1<VTH & r_inv2_1>=VTH) begin
			r_inv1_2 = VSS;
			r_inv2_2 = r_inv2_1;
		end else if(r_inv2_1<VTH & r_inv1_1>=VTH) begin
			r_inv1_2 = r_inv1_1;
			r_inv2_2 = VSS;
		end else begin
			r_inv1_2 = r_inv1_2;
			r_inv2_2 = r_inv2_2;
		end
	end
	
	nmosfet nmos3(
	.vd (r_inv1_2),
	.vg (row_rd),
	.vs (bl_rd)
	);
	
	nmosfet nmos4(
	.vd (r_inv2_2),
	.vg (row_rd),
	.vs (blb_rd)
	);
	
endmodule
