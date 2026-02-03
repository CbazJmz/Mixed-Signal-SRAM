module sense_amp#(
    parameter COLS=16)(
    input  real bl_rd [0:COLS-1],      //BL line from memory array
    input  real blb_rd [0:COLS-1],     //BLB line from memory array
    output real preout [0:COLS-1]      //Output from diff amplifiers
);

//   ________________________________
//  |              VDD   |    VSS    |
//  |--------------------------------|
//  |Typ Voltage|  1.5   |    0.0    |
//  |________________________________|

const real VDD =  1.5;
const real VSS =  0.0;
const real VTH =  0.8; 

    genvar i;
    //Generate diff amplifiers array
    generate
        for(i=0;i<COLS;i++) begin: COL
            assign preout [i] = bl_rd [i] > blb_rd [i] ? VDD : VSS;
        end
    endgenerate

endmodule
