module scell (
    input  logic row_wr,
	input  logic row_rd,
    input  logic bl_wr,
    input  logic blb_wr,
	output real bl_rd,
	output real blb_rd
);
    
	typedef enum logic [1:0] {
    DATA_TRUE,      // True
    DATA_FALSE,     // False
    INDET       	// Indeterminated
} state_data;
	
// As stated in Table 1 of  ERS, the VDD, and VSS pads have the following specifications
//   ________________________________
//  |             TRUE   |   FALSE   |
//  |--------------------------------|
//  |Min Voltage|  1.3   |   -0.5    |
//  |Typ Voltage|  1.5   |    0.0    |
//  |Max Voltage|  2.2   |    0.7    |
//  |________________________________|
	
	const real TRUE_MIN =  1.3;
	const real TRUE_MAX =  2.2;
	const real FALSE_MIN = -0.5;
	const real FALSE_MAX =  0.7;
	
	// NMOS and NOT Gates nodes
    wire inv1;
    wire inv2;
    // Memory cell structure
    nmos nmos1(inv1,bl_wr,row_wr);
    nmos nmos2(blb_wr,inv2,row_wr);
	nmos nmos3(inv1,bl_rd,row_rd);
    nmos nmos4(blb_rd,inv2,row_rd);
    not not1(inv2,inv1);
    not not2(inv1,inv2);
	
endmodule
