module sram_cell (
    input  logic row,
    inout  logic bl_col,
    inout  logic blb_col
);
    // NMOS and NOT Gates nodes
    logic inv1;
    logic inv2;
    // Memory cell structure
    nmos nmos1(inv1,bl_col,row);
    nmos nmos2(blb_col,inv2,row);
    not not1(inv2,inv1);
    not not2(inv1,inv2);

endmodule
