module sense_amp(
    input  real bl_col,      //BL line from memory array
    input  real blb_col,     //BLB line from memory array
    output logic preout       //Output from diff amplifiers
);

            assign preout = bl_col > blb_col ? 1'b1 : 1'b0;

endmodule
