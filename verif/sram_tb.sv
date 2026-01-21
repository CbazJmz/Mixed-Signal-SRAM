module tb_sram_mixed_xcelium;

    localparam int DATA_WIDTH = 8;
    localparam int ADDR_WIDTH = 4;
    localparam real VDD = 1.8;

    logic clk;
    logic we;
    logic [ADDR_WIDTH-1:0] addr;
    logic [DATA_WIDTH-1:0] din;
    logic [DATA_WIDTH-1:0] dout;

    sram_mixed_xcelium #(
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
    // Write task
    // -----------------------------
    task write_mem(input int a, input byte d);
        we = VDD;
        for (int i = 0; i < ADDR_WIDTH; i++)
            addr[i] = a[i] ? VDD : 0.0;
        for (int i = 0; i < DATA_WIDTH; i++)
            din[i] = d[i] ? VDD : 0.0;
        @(posedge clk);
        we = 0.0;
    endtask

    // -----------------------------
    // Read task
    // -----------------------------
    task read_mem(input int a);
        we = 0.0;
        for (int i = 0; i < ADDR_WIDTH; i++)
            addr[i] = a[i] ? VDD : 0.0;
        @(posedge clk);
    endtask

    // -----------------------------
    // Stimulus
    // -----------------------------
    initial begin
        we = 0.0;
        addr = '{default:0.0};
        din  = '{default:0.0};

        #30;

        $display("WRITE addr=3 data=0xAA");
        write_mem(3, 8'hAA);

        #30;

        $display("READ addr=3");
        read_mem(3);

        #30;

        $display("READ-FIRST test (expect old data)");
        write_mem(3, 8'h55);

        #80;
        $finish;
    end

endmodule
