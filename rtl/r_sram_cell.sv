module sram_cell (
    input  real row_wr,
	input  real row_rd,
    input  real bl_wr,
    input  real blb_wr,
	output logic bl_rd,
	output logic blb_rd
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
	real r_bl_rd;
	real r_blb_rd;
	
	logic l_row_wr;
	logic l_row_rd;
	logic inv1;
	logic inv2;
	
	assign l_row_rd = row_rd >= VTH ? 1'b1 : 1'b0;
	assign l_row_wr = row_wr >= VTH ? 1'b1 : 1'b0;
	
    // Memory cell structure
    nmosfet nmos1(
	.vd (bl_wr),
	.vg (l_row_wr),
	.vs (r_inv1_1)
	);
	
	nmosfet nmos2(
	.vd (blb_wr),
	.vg (l_row_wr),
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
	.vg (l_row_rd),
	.vs (r_bl_rd)
	);
	
	nmosfet nmos4(
	.vd (r_inv2_2),
	.vg (l_row_rd),
	.vs (r_blb_rd)
	);
	
	assign bl_rd = r_bl_rd >= VTH ? 1'b1:1'b0;
	assign blb_rd = r_blb_rd >= VTH ? 1'b1:1'b0;
	
endmodule
