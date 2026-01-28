module sram_cell (
    input  logic row_wr,
    input  real bl_col,
    input  real blb_col,
	output real obl_col,
	output real oblb_col
);
    // NMOS and NOT Gates nodes
    real inv1;
    real inv2;
    // Memory cell structure
    nmos nmos1(inv1,bl_col,row);
    nmos nmos2(blb_col,inv2,row);
    not not1(inv2,inv1);
    not not2(inv1,inv2);
	
	assign obl_col = inv1;
	assign oblb_col = inv2;

endmodule
