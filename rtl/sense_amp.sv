module sense_amp#(
    parameter COLS=16)(
    input  wire [COLS-1:0] bl_rd,      //BL line from memory array
    input  wire [COLS-1:0] blb_rd,     //BLB line from memory array
    output logic [COLS-1:0] preout       //Output from diff amplifiers
);

    genvar i;
    //Generate diff amplifiers array
    generate
        for(i=0;i<COLS;i++) begin: COL
            assign preout [i] = bl_rd [i] > blb_rd [i] ? 1'b1 : 1'b0;

        end
    endgenerate

endmodule
