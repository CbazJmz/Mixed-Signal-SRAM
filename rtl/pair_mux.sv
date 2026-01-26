module pair_mux#(
    parameter COLS=16)(
    input  logic rd_wr,                 //Read or Write selector
    input  logic [COLS-1:0] bl_wr,      //BL line from write circuit
    input  logic [COLS-1:0] blb_wr,     //BLB line from write circuit
    input  logic [COLS-1:0] bl_rd,      //BL line from pre-charge circuit
    input  logic [COLS-1:0] blb_rd,     //BLB line from pre-charge circuit
    output logic [COLS-1:0] bl_col,     //BL line to memory array
    output logic [COLS-1:0] blb_col     //BLB line to memory array
);
    // rd_wr = 1'b1     Read operation
    // rd_wr = 1'b0     Write operation
    assign bl_col = rd_wr ? bl_rd : bl_wr;
    assign blb_col = rd_wr ? blb_rd : blb_wr;

endmodule
