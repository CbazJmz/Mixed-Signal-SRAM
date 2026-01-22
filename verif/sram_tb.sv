module sram_tb;

    //-------------------------------------------------
    // Parámetros
    //-------------------------------------------------
    localparam int DATA_WIDTH = 8;
    localparam int ADDR_WIDTH = 4;
    localparam int ANA_WIDTH  = 8;

    localparam int FULL_SCALE = 255;

    localparam int DEPTH = 1 << ADDR_WIDTH;

    //-------------------------------------------------
    // Señales "analógicas" emuladas
    //-------------------------------------------------
    logic [ANA_WIDTH-1:0] clk_a;
    logic [ANA_WIDTH-1:0] we_a;

    logic [ANA_WIDTH-1:0] addr_a [ADDR_WIDTH];
    logic [ANA_WIDTH-1:0] din_a  [DATA_WIDTH];
    logic [ANA_WIDTH-1:0] dout_a [DATA_WIDTH];

    //-------------------------------------------------
    // DUT
    //-------------------------------------------------
    sram #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .ANA_WIDTH (ANA_WIDTH)
    ) dut (
        .clk_a (clk_a),
        .we_a  (we_a),
        .addr_a(addr_a),
        .din_a (din_a),
        .dout_a(dout_a)
    );

    //-------------------------------------------------
    // Clock
    //-------------------------------------------------
    initial begin
        clk_a = 0;
        forever #10 clk_a = (clk_a == 0) ? FULL_SCALE : 0;
    end

    //-------------------------------------------------
    // Helpers
    //-------------------------------------------------
    function byte dout_to_byte();
        byte tmp;
        for (int i = 0; i < DATA_WIDTH; i++)
            tmp[i] = (dout_a[i] > (FULL_SCALE/2));
        return tmp;
    endfunction

    task set_addr(input int a);
        for (int i = 0; i < ADDR_WIDTH; i++)
            addr_a[i] = a[i] ? FULL_SCALE : 0;
    endtask

    task set_data(input byte d);
        for (int i = 0; i < DATA_WIDTH; i++)
            din_a[i] = d[i] ? FULL_SCALE : 0;
    endtask

    //-------------------------------------------------
    // Write
    //-------------------------------------------------
    task write_mem(input int a, input byte d);
        set_addr(a);
        set_data(d);
        we_a = FULL_SCALE;
        @(posedge clk_a);
        we_a = 0;
    endtask

    //-------------------------------------------------
    // Read
    //-------------------------------------------------
    task read_mem(input int a, output byte d);
        set_addr(a);
        we_a = 0;
        @(posedge clk_a);
        #1; // esperar retardo
        d = dout_to_byte();
    endtask

    //-------------------------------------------------
    // Test principal
    //-------------------------------------------------
    int errors = 0;
    byte rdata;

    initial begin
        we_a = 0;
        foreach (addr_a[i]) addr_a[i] = 0;
        foreach (din_a[i])  din_a[i]  = 0;

        #20;

        $display("\n==============================");
        $display(" ESCRITURA SECUENCIAL");
        $display("==============================");

        // -------------------------
        // WRITE: 0,1,2,3,...,DEPTH-1
        // -------------------------
        for (int i = 0; i < DEPTH; i++) begin
            write_mem(i, i);
        end

        #40;

        $display("\n==============================");
        $display(" LECTURA + VERIFICACION");
        $display("==============================");

        // -------------------------
        // READ + CHECK
        // -------------------------
        for (int i = 0; i < DEPTH; i++) begin
            read_mem(i, rdata);

            if (rdata !== i[7:0]) begin
                $display("ERROR addr=%0d expected=%0d got=%0d",
                          i, i, rdata);
                errors++;
            end
            else begin
                $display("OK addr=%0d data=%0d", i, rdata);
            end
        end

        //-------------------------------------------------
        // Resultado
        //-------------------------------------------------
        if (errors == 0)
            $display("\n TEST PASS");
        else
            $display("\n TEST FAIL — errores=%0d", errors);

        #40;
        $finish;
    end

endmodule

