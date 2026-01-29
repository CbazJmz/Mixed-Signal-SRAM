module sram #(
    parameter ROWS=16,
    parameter COLS=8
)(
    input   logic [COLS-1:0] data_in,
    input   logic [$clog2(ROWS)-1:0] row_sel,
    input   logic rd_wr,
    output  logic [COLS-1:0] data_out
);

    logic   [ROWS-1:0] row;
    logic   [COLS-1:0] bl_wr;
    logic   [COLS-1:0] blb_wr;
    logic   [COLS-1:0] bl_rd;
    logic   [COLS-1:0] blb_rd;
    
    logic   [COLS-1:0] bl_col;
    logic   [COLS-1:0] blb_col;
    
    logic   [COLS-1:0] preout;
    
    
    decoder #(ROWS) dec (
        .row_sel  (row_sel),
        .row (row)
    );

    precharge #(COLS) pre(
        .rd_wr  (rd_wr),
        .bl_rd (bl_rd),
        .blb_rd  (blb_rd)
    );

    write_driver #(COLS) wd(
        .data_in  (data_in),
        .bl_wr  (bl_wr),
        .blb_wr  (blb_wr)
    );

    pair_mux #(COLS) pm(
        .bl_wr  (bl_wr),
        .blb_wr  (blb_wr),
        .bl_rd  (bl_rd),
        .blb_rd  (blb_rd),
        .bl_col  (bl_col),
        .blb_col  (blb_col),
        .rd_wr  (rd_wr)
    );

    cell_array #(ROWS,COLS) ca(
        .bl_col  (bl_col),
        .blb_col  (blb_col),
        .row    (row)
        );

    sense_amp #(COLS) sa(
        .bl_col  (bl_col),
        .blb_col  (blb_col),
        .preout  (preout)
        );

    assign data_out = rd_wr ? preout : '0;

endmodule
