module write_driver (
    input logic data_in,
    input real bl_wr,
    input real blb_wr
);
    // To set 1 in sram cell    bl = VDD    blb = GND
    // To set 0 in sram cell    bl = GND    blb = VDD
            assign bl_wr  = data_in ? 1'b1 : 1'b0;
            assign blb_wr = data_in ? 1'b0 : 1'b1;
endmodule
