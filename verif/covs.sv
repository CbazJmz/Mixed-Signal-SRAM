module cov_sram (
    input logic clk,
    input logic arst_n,
    input logic serial_in,
    input logic load,
    input logic w_en,
    input logic r_en,
    input logic shift,
    input logic [$clog2(ROWS)-1:0] addr,
    input logic data_valid,
    input logic [COLS-1:0] data_out
);

    localparam ADDR_WIDTH = $clog2(ROWS);

    covergroup ctrl_cg @(posedge clk);
        option.per_instance = 1;

        load_cp: coverpoint load {
            bins rise  = (0 => 1);
            bins fall  = (1 => 0);
            bins value[] = {0,1};
        }

        shift_cp: coverpoint shift {
            bins rise  = (0 => 1);
            bins fall  = (1 => 0);
            bins value[] = {0,1};
        }

        w_en_cp: coverpoint w_en {
            bins rise  = (0 => 1);
            bins fall  = (1 => 0);
            bins value[] = {0,1};
        }

        r_en_cp: coverpoint r_en {
            bins rise  = (0 => 1);
            bins fall  = (1 => 0);
            bins value[] = {0,1};
        }

        // Tipos de operación
        op_cp: coverpoint {w_en, r_en} {
            bins idle      = {2'b00};
            bins write     = {2'b10};
            bins read      = {2'b01};
            bins readwrite = {2'b11};  // simultáneo permitido
        }

    endgroup


    covergroup addr_cg @(posedge clk);
        option.per_instance = 1;

        addr_cp: coverpoint addr {
            bins all_addr[] = {[0:ROWS-1]};
        }

        addr_edges: coverpoint addr {
            bins first = {0};
            bins last  = {ROWS-1};
        }

    endgroup


    covergroup data_cg @(posedge clk);
        option.per_instance = 1;

        data_valid_cp: coverpoint data_valid {
            bins rise  = (0 => 1);
            bins fall  = (1 => 0);
            bins value[] = {0,1};
        }

        // Solo cubrir datos cuando son válidos
        data_out_cp: coverpoint data_out iff (data_valid) {
            bins data_dist[64] = {[0:(1<<COLS)-1]};
        }

    endgroup


    covergroup rw_addr_cg @(posedge clk);
        option.per_instance = 1;

        rw_simultaneous_addr: coverpoint addr iff (w_en && r_en) {
            bins all_addr[] = {[0:ROWS-1]};
        }

    endgroup


    covergroup op_addr_cg @(posedge clk);
        option.per_instance = 1;

        op_cp: coverpoint {w_en, r_en} {
            bins write     = {2'b10};
            bins read      = {2'b01};
            bins readwrite = {2'b11};
        }

        addr_cp: coverpoint addr {
            bins all_addr[] = {[0:ROWS-1]};
        }

        op_addr_cross: cross op_cp, addr_cp;

    endgroup

    ctrl_cg       ctrl_cg_i       = new();
    addr_cg       addr_cg_i       = new();
    data_cg       data_cg_i       = new();
    rw_addr_cg    rw_addr_cg_i    = new();
    op_addr_cg    op_addr_cg_i    = new();

endmodule: cov_sram
