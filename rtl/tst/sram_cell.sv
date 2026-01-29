module sram_cell (
    input  logic row_wr,
	input  logic row_rd,
    input  wire bl_col,
    input  wire blb_col,
	output wire obl_col,
	output wire oblb_col
);
    // NMOS and NOT Gates nodes
    wire inv1;
    wire inv2;
    // Memory cell structure
    nmos nmos1(inv1,bl_col,row_wr);
    nmos nmos2(blb_col,inv2,row_wr);
	nmos nmos3(inv1,obl_col,row_rd);
    nmos nmos4(oblb_col,inv2,row_rd);
    not not1(inv2,inv1);
    not not2(inv1,inv2);
	
endmodule
