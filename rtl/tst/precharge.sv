module precharge #(
    parameter COLS=8)(
    input real rd_wr,
    output real bl_rd [0:COLS-1],
    output real blb_rd [0:COLS-1]
);

//   ________________________________
//  |              VDD   |    VSS    |
//  |--------------------------------|
//  |Typ Voltage|  1.5   |    0.0    |
//  |________________________________|

const real VDD =  1.5;
const real VSS =  0.0;
const real VTH =  0.8; 
	
	logic l_rd_wr;
	assign l_rd_wr = rd_wr >= VTH ? 1'b1 : 1'b0;
	
    // Set bl and blb lines to read operation
    genvar i;
    generate
        for(i=0;i<COLS;i++) begin
            assign bl_rd[i]  = l_rd_wr ? VDD : VSS;
            assign blb_rd[i] = l_rd_wr ? VDD : VSS;
        end
    endgenerate
endmodule
