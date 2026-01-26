module precharge #(
    parameter COLS=8)(
    input logic rd_wr,
    output logic [COLS-1:0] bl_rd,
    output logic [COLS-1:0] blb_rd
);
    // Set bl and blb lines to read operation
    genvar i;
    generate
        for(i=0;i<COLS;i++) begin
            assign bl_rd[i]  = rd_wr ? 1'b1 : 1'b0;
            assign blb_rd[i] = rd_wr ? 1'b1 : 1'b0;
        end
    endgenerate
endmodule
