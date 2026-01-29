module cell_array #(
    parameter ROWS=16, COLS=8)(
    input  logic [ROWS-1:0] row,
    inout  tri [COLS-1:0] bl_col,
    inout  tri [COLS-1:0] blb_col
);
    //Rows and columns variables
    genvar r,c;
    //Generate memory array
    generate
        for(r=0;r<ROWS;r++) begin: ROW
            for(c=0;c<COLS;c++) begin: COL
                sram_cell cell1(
                    .row (row[r]),
                    .bl_col (bl_col[c]),
                    .blb_col(blb_col[c])
                );
            end
        end
    endgenerate
endmodule
