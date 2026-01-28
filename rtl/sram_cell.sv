module sram_cell (
    input  logic row_wr,
    input  wire bl_col,
    input  wire blb_col,
	output real obl_col,
	output real oblb_col
);
    // NMOS and NOT Gates nodes
    wire inv1;
    wire inv2;
    // Memory cell structure
    nmos nmos1(inv1,bl_col,row);
    nmos nmos2(blb_col,inv2,row);
    not not1(inv2,inv1);
    not not2(inv1,inv2);
	
	assign obl_col = inv1;
	assign oblb_col = inv2;

endmodule
