module sense_amp(
    input  real bl_rd,      //BL line from memory array
    input  real blb_rd,     //BLB line from memory array
    output real preout       //Output from diff amplifiers
);

//   ________________________________
//  |              VDD   |    VSS    |
//  |--------------------------------|
//  |Typ Voltage|  1.5   |    0.0    |
//  |________________________________|

const real VDD =  1.5;
const real VSS =  0.0;
const real VTH =  0.8;

    assign preout = bl_rd > blb_rd ? VDD : VSS;

endmodule
