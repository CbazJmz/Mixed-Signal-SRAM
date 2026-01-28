module precharge (
    input logic rd_wr,
    input real bl_rd,
    input real blb_rd
);
    // Set bl and blb lines to read operation
            assign bl_rd  = rd_wr ? 1'b1 : 1'b0;
            assign blb_rd = rd_wr ? 1'b1 : 1'b0;
endmodule
