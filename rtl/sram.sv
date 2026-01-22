module sram_digital_emulated #(
    parameter int DATA_WIDTH   = 8,
    parameter int ADDR_WIDTH   = 4,
    parameter int ANA_WIDTH    = 8,      // resolución "analógica"
    parameter int FULL_SCALE   = 255,    // emula VDD
    parameter int THRESHOLD    = 128,    // emula VTH
    parameter time T_RD        = 5ns,
    parameter time T_WR        = 5ns
)(
    input  logic [ANA_WIDTH-1:0]               clk_a,
    input  logic [ANA_WIDTH-1:0]               we_a,
    input  logic [ANA_WIDTH-1:0]               addr_a [ADDR_WIDTH],
    input  logic [ANA_WIDTH-1:0]               din_a  [DATA_WIDTH],
    output logic [ANA_WIDTH-1:0]               dout_a [DATA_WIDTH]
);

    // -----------------------------
    // Memoria digital real
    // -----------------------------
    logic [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];
    logic [DATA_WIDTH-1:0] read_data, dout_reg;

    logic clk_d, we_d;
    int address;

    // -----------------------------
    // "ADC" digital
    // -----------------------------
    always_comb begin
        clk_d = (clk_a > THRESHOLD);
        we_d  = (we_a  > THRESHOLD);

        address = 0;
        for (int i = 0; i < ADDR_WIDTH; i++)
            if (addr_a[i] > THRESHOLD)
                address |= (1 << i);
    end

    // -----------------------------
    // SRAM READ-FIRST
    // -----------------------------
    always_ff @(posedge clk_d) begin
        read_data <= mem[address]; // leer primero

        if (we_d) begin
            #(T_WR);
            for (int i = 0; i < DATA_WIDTH; i++)
                mem[address][i] <= (din_a[i] > THRESHOLD);
        end
    end

    // -----------------------------
    // Retardo lectura
    // -----------------------------
    always @(read_data)
        dout_reg <= #(T_RD) read_data;

    // -----------------------------
    // "DAC" digital
    // -----------------------------
    genvar k;
    generate
        for (k = 0; k < DATA_WIDTH; k++) begin
            always_comb begin
                dout_a[k] = dout_reg[k] ? FULL_SCALE : 0;
            end
        end
    endgenerate

endmodule
