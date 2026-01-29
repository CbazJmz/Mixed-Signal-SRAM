module decoder #(
    parameter ROWS=16)(
    input  logic [$clog2(ROWS)-1:0] row_sel,
    output logic [ROWS-1:0] row
);
    //Onehot decoder
    assign row = row_sel==0 ? '0 : '0 + (1'b1 << (row_sel-1));

endmodule
