module sense_amp#(
    parameter COLS=16)(
    input  real [COLS-1:0] obl_col,      //BL line from memory array
    input  real [COLS-1:0] oblb_col,     //BLB line from memory array
    output logic [COLS-1:0] preout       //Output from diff amplifiers
);

    genvar i;
    //Generate diff amplifiers array
    generate
        for(i=0;i<COLS;i++) begin: COL
            assign preout [i] = obl_col [i] > oblb_col [i] ? 1'b1 : 1'b0;

        end
    endgenerate

endmodule
