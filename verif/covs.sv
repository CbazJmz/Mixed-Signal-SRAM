module cov_sram (
	input logic clk,
	input logic arst_n,

	input logic serial_in,
	input logic shift,
	input logic w_en,
	input logic r_en,
	input logic [$clog2(ROWS)-1:0]addr,
	input logic data_valid,
	input logic [COLS-1:0]data_out
);

	`define SRAM_PATH sram1

	covergroup wr_port_cg @(posedge clk);
		option.per_instance = 1;

		wren_change: coverpoint w_en {
		bins rise = (0 => 1);
		bins fall = (1 => 0);
		}
		wren_value: coverpoint w_en { bins value[] = {0, 1}; }

	endgroup: wr_port_cg

	covergroup rd_port_cg @(posedge clk);
		option.per_instance = 1;

		rden_change: coverpoint r_en {
		bins rise = (0 => 1);
		bins fall = (1 => 0);
		}
		rden_value: coverpoint r_en { bins value[] = {0, 1}; }

	endgroup: rd_port_cg

endmodule: cov_sram
