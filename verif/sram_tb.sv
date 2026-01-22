module sram_tb;

    localparam int DATA_WIDTH = 8;
    localparam int ADDR_WIDTH = 4;
    localparam int ANA_WIDTH  = 8;
    localparam int FULL_SCALE = 255;

    logic [ANA_WIDTH-1:0] clk_a;
    logic [ANA_WIDTH-1:0] we_a;
    logic [ANA_WIDTH-1:0] addr_a [ADDR_WIDTH];
    logic [ANA_WIDTH-1:0] din_a  [DATA_WIDTH];
    logic [ANA_WIDTH-1:0] dout_a [DATA_WIDTH];

    sram dut (
        .clk_a (clk_a),
        .we_a  (we_a),
        .addr_a(addr_a),
        .din_a (din_a),
        .dout_a(dout_a)
    );

    // -----------------------------
    // Clock "analógico" digital
    // -----------------------------
    initial begin
        clk_a = 0;
        forever #10 clk_a = (clk_a == 0) ? FULL_SCALE : 0;
    end

    // -----------------------------
    // Tasks
    // -----------------------------
    task write_mem(input int a, input byte d);
        we_a = FULL_SCALE;
        for (int i = 0; i < ADDR_WIDTH; i++)
            addr_a[i] = a[i] ? FULL_SCALE : 0;
        for (int i = 0; i < DATA_WIDTH; i++)
            din_a[i] = d[i] ? FULL_SCALE : 0;
        @(posedge clk_a);
        we_a = 0;
    endtask

    task read_mem(input int a);
        we_a = 0;
        for (int i = 0; i < ADDR_WIDTH; i++)
            addr_a[i] = a[i] ? FULL_SCALE : 0;
        @(posedge clk_a);
    endtask

    // -----------------------------
    // Stimulus
    // -----------------------------
    initial begin
        we_a = 0;
        foreach (addr_a[i]) addr_a[i] = 0;
        foreach (din_a[i])  din_a[i]  = 0;

        #20;

        $display("WRITE addr=2 data=0xA5");
        write_mem(2, 8'hA5);

        #20;

        $display("READ addr=2");
        read_mem(2);

        #20;

        $display("READ-FIRST test (write 0x3C, expect 0xA5)");
        write_mem(2, 8'h3C);

        #80;
        $finish;
    end
    
	initial begin
		$shm_open("shm_db");
		$shm_probe("ASMTR");
	end

	// Timeout
	initial begin
	#1ms;
	$finish;
	end

endmodule
