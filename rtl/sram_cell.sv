module sram_cell (
    input  wire row,
    inout  wire bl_col,
    inout  wire blb_col
);
    // NMOS and NOT Gates nodes
    wire inv1;
    wire inv2;
    // Memory cell structure
    nmos nmos1(inv1,bl_col,row);
    nmos nmos2(blb_col,inv2,row);
    not not1(inv2,inv1);
    not not2(inv1,inv2);

endmodule
