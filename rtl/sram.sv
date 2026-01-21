module sram_mixed_xcelium #(
    parameter int  DATA_WIDTH = 8,
    parameter int  ADDR_WIDTH = 4,
    parameter real VDD        = 1.8,
    parameter real VTH        = 0.9,
    parameter time T_RD       = 5ns,
    parameter time T_WR       = 5ns
)(
    input  wreal                    clk,
    input  wreal                    we,
    input  wreal [ADDR_WIDTH-1:0]   addr,
    input  wreal [DATA_WIDTH-1:0]   din,
    output wreal [DATA_WIDTH-1:0]   dout
);

    // -----------------------------
    // Núcleo digital
    // -----------------------------
    logic [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];
    logic [DATA_WIDTH-1:0] dout_reg;
    logic [DATA_WIDTH-1:0] read_data;

    logic clk_d, we_d;
    int address;

    // -----------------------------
    // A/D conversion
    // -----------------------------
    always_comb begin
        clk_d = (clk > VTH);
        we_d  = (we  > VTH);

        address = 0;
        for (int i = 0; i < ADDR_WIDTH; i++)
            if (addr[i] > VTH)
                address |= (1 << i);
    end

    // -----------------------------
    // READ-FIRST behavior
    // -----------------------------
    always_ff @(posedge clk_d) begin
        read_data <= mem[address];  // leer primero

        if (we_d) begin
            for (int i = 0; i < DATA_WIDTH; i++)
                mem[address][i] <= (din[i] > VTH);
        end
    end

    // -----------------------------
    // Retardo de lectura
    // -----------------------------
    always @(read_data) begin
        dout_reg <= #(T_RD) read_data;
    end

    // -----------------------------
    // D/A conversion
    // -----------------------------
    genvar k;
    generate
        for (k = 0; k < DATA_WIDTH; k++) begin
            assign dout[k] = dout_reg[k] ? VDD : 0.0;
        end
    endgenerate

endmodule
