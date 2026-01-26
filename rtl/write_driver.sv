module write_driver #(
    parameter COLS=8)(
    input  logic [COLS-1:0] data_in,
    output logic [COLS-1:0] bl_wr,
    output logic [COLS-1:0] blb_wr
);
    // To set 1 in sram cell    bl = VDD    blb = GND
    // To set 0 in sram cell    bl = GND    blb = VDD
    genvar i;
    generate
        for(i=0;i<COLS;i++) begin
            assign bl_wr[i]  = data_in[i] ? 1'b1 : 1'b0;
            assign blb_wr[i] = data_in[i] ? 1'b0 : 1'b1;
        end
    endgenerate
endmodule
