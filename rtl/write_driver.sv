module write_driver (
    input real data_in,
    output real bl_wr,
    output real blb_wr
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
	
	assign bl_wr  = data_in >= VTH ? data_in : VSS;
    assign blb_wr = data_in >= VTH ? VSS : data_in;
	
endmodule
