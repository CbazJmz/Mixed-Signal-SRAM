module tb_sram_mixed;

    localparam int DATA_WIDTH = 8;
    localparam int ADDR_WIDTH = 4;
    localparam real VDD = 1.8;

    // Señales mixed-signal
    wreal clk;
    wreal we;
    wreal [ADDR_WIDTH-1:0] addr;
    wreal [DATA_WIDTH-1:0] din;
    wreal [DATA_WIDTH-1:0] dout;

    // DUT
    sram_mixed_readfirst #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk(clk),
        .we(we),
        .addr(addr),
        .din(din),
        .dout(dout)
    );

    // -----------------------------
    // Clock analógico
    // -----------------------------
    initial begin
        clk = 0.0;
        forever #10 clk = (clk == 0.0) ? VDD : 0.0;
    end

    // -----------------------------
    // Task: escribir
    // -----------------------------
    task write_mem(input int a, input byte d);
        begin
            we = VDD;
            for (int i = 0; i < ADDR_WIDTH; i++)
                addr[i] = a[i] ? VDD : 0.0;
            for (int i = 0; i < DATA_WIDTH; i++)
                din[i] = d[i] ? VDD : 0.0;
            @(posedge clk);
            we = 0.0;
        end
    endtask

    // -----------------------------
    // Task: leer
    // -----------------------------
    task read_mem(input int a);
        begin
            we = 0.0;
            for (int i = 0; i < ADDR_WIDTH; i++)
                addr[i] = a[i] ? VDD : 0.0;
            @(posedge clk);
        end
    endtask

    // -----------------------------
    // Stimulus
    // -----------------------------
    initial begin
        we = 0.0;
        addr = '{default:0.0};
        din  = '{default:0.0};

        #20;

        $display("=== ESCRITURA addr=3, data=0xAA ===");
        write_mem(3, 8'hAA);

        #20;

        $display("=== LECTURA addr=3 ===");
        read_mem(3);

        #20;

        $display("=== READ-FIRST TEST ===");
        $display("Escribiendo 0x55 en addr=3, salida debe ser 0xAA");
        write_mem(3, 8'h55);

        #50;
        $finish;
    end

endmodule
