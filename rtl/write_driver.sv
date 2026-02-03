module write_driver #(
    parameter COLS=8)(
    input real data_in [0:COLS-1],
    output real bl_wr [0:COLS-1],
    output real blb_wr [0:COLS-1]
);
    // To set 1 in sram cell    bl = VDD    blb = GND
    // To set 0 in sram cell    bl = GND    blb = VDD
	
//   ________________________________
//  |              VDD   |    VSS    |
//  |--------------------------------|
//  |Typ Voltage|  1.5   |    0.0    |
//  |________________________________|

const real VDD =  1.5;
const real VSS =  0.0;
const real VTH =  0.8; 
	
    genvar i;
    generate
        for(i=0;i<COLS;i++) begin
            assign bl_wr [i]  = data_in [i] >= VTH ? VDD : VSS;
            assign blb_wr [i] = data_in [i] >= VTH ? VSS : VDD;
        end
    endgenerate
endmodule
