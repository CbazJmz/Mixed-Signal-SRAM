module sram_cell (
    input  logic row_wr,
	input  logic row_rd,
    input  wire bl_wr,
    input  wire blb_wr,
	output wire bl_rd,
	output wire blb_rd
);
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
