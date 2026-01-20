module sram_mixed_readfirst #(
    parameter int  DATA_WIDTH = 8,
    parameter int  ADDR_WIDTH = 4,
    parameter real VDD        = 1.8,
    parameter real VTH        = 0.9,
    parameter time T_RD       = 5ns,   // retardo de lectura
    parameter time T_WR       = 5ns    // retardo de escritura
)(
    input  wreal                    clk,
    input  wreal                    we,
    input  wreal [ADDR_WIDTH-1:0]   addr,
    input  wreal [DATA_WIDTH-1:0]   din,
    output wreal [DATA_WIDTH-1:0]   dout
);

    // -----------------------------
    // Memoria digital
    // -----------------------------
    logic [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];
    logic [DATA_WIDTH-1:0] dout_reg;

    logic clk_d, we_d;
    int address;

    // -----------------------------
    // A/D: analógico → digital
    // -----------------------------
    always_comb begin
        clk_d = (clk > VTH);
        we_d  = (we  > VTH);

        address = 0;
        for (int i = 0; i < ADDR_WIDTH; i++) begin
            if (addr[i] > VTH)
                address |= (1 << i);
        end
    end

    // -----------------------------
    // SRAM READ-FIRST
    // -----------------------------
    always_ff @(posedge clk_d) begin
        // 1️⃣ Leer primero
        dout_reg <= #(T_RD) mem[address];

        // 2️⃣ Luego escribir
        if (we_d) begin
            #(T_WR);
            for (int i = 0; i < DATA_WIDTH; i++) begin
                mem[address][i] <= (din[i] > VTH);
            end
        end
    end

    // -----------------------------
    // D/A: digital → analógico
    // -----------------------------
    genvar k;
    generate
        for (k = 0; k < DATA_WIDTH; k++) begin
            assign dout[k] = dout_reg[k] ? VDD : 0.0;
        end
    endgenerate

endmodule
