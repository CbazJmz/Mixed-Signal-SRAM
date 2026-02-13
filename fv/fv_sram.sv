module fv_sfifo (
	input logic clk,
	input logic arst_n,
	input logic [$clog2(ROWS)-1:0]addr,
	// Writing port //
	input logic w_en,
	input logic serial_in,
	input logic shift,

	// Reading port //
	input logic r_en,
	output logic data_valid,
	output logic [COLS-1:0]data_out
);

  `ifdef SFIFO_TOP
    `define SFIFO_ASM 1
  `else
    `define SFIFO_ASM 0
  `endif

  // NDCs //
  logic [$clog2(ROWS)-1:0] ptr_ndc;
  logic [$clog2(ROWS):0] tb_num_entries;
 
  asm_ndc_stable: assume property (@(posedge clk) $stable(ptr_ndc));

	// Task: send serial word
	task send_serial_word(input logic [COLS-1:0] word);
		integer i;
		begin
			for (i = COLS-1; i >= 0; i--) begin
				serial_in = word[i];
				shift  = 1'b1;
				repeat (2) @(posedge clk);
			end
			shift = 1'b0;
		end
	endtask

  // TB signals //
  logic [COLS-1:0] tb_wr_data;
  logic tb_wr_data_vd;
  logic [COLS-1:0] tb_rd_data;
  logic tb_rd_data_vd;

  always_ff@(posedge clk, negedge arst_n) begin
    if(~arst_n) begin
      tb_wr_data <= 'd0;
      tb_wr_data_vd <= 1'b0;
    end else begin
      if(w_en && (~tb_wr_data_vd) && (addr == ptr_ndc)) begin
        tb_wr_data_vd <= 1'b1;
        tb_wr_data <= wdata;
      end
    end
  end

  always_ff@(posedge clk, negedge arst_n) begin
    if(~arst_n) begin
      tb_rd_data <= 'd0;
      tb_rd_data_vd <= 1'b0;
    end else begin
      if(rden && (~tb_rd_data_vd)) begin
        tb_rd_data_vd <= 1'b1;
        tb_rd_data <= rdata;
      end
    end
  end

  always_ff@(posedge clk, negedge arst_n) begin
    if(~arst_n) begin
      tb_num_entries <= '0;
    end else begin
      if(wren && (~rden)) begin
        tb_num_entries <= tb_num_entries + 1'b1;
      end else if(rden && (~wren)) begin
        tb_num_entries <= tb_num_entries - 1'b1;
      end else begin
        tb_num_entries <= tb_num_entries;
      end
    end
  end
  `ifndef SIM_RUN
    // no read when empty
    `REUSE(`SFIFO_ASM, sfifo, no_read_when_empty, empty |->, ~rden )

    // no write when full
    `REUSE(`SFIFO_ASM, sfifo, no_write_when_full, full |->, ~wren )
  `else
    // no read when empty
    `AST(sfifo, no_read_when_empty, empty |->, ~rden )

    // no write when full
    `AST(sfifo, no_write_when_full, full |->, ~wren )
  `endif

  // fifo can't be full and empty at the same time
  `AST(sfifo, no_full_and_empty, 1'b1 |->, ~(full && empty) )

  // if wrptr and rdptr are equal, fifo is either full or empty
  `AST(sfifo, full_or_empty_if_ptrs_equal, (wrptr == rdptr) |->, (full || empty) )

  // if a data is written into the fifo, eventually it must be read
  `AST(sfifo, data_read_after_data_written, (wren && (~full) && (~tb_wr_data_vd) && (wrptr == ptr_ndc)) |->, (rdptr == ptr_ndc) |=> (rdata == tb_wr_data) )

  // there must not be more entries than the size of the fifo
  `AST(sfifo, num_entries_greater_than_size, 1'b1 |->, tb_num_entries <= ROWS )

  // if pre_full is set, full must be set at the next clock cycle
  `AST(sfifo, full_next_cycle_if_pre_full, pre_full |=>, full )

  // if full is set, pre_full must have been set in the previous clock cycle
  `AST(sfifo, pre_full_previous_cycle_if_full, $rose(full) |->, $past(pre_full) )

  // if pre_empty is set, empty must be set at the next clock cycle
  `AST(sfifo, empty_next_cycle_if_pre_empty, pre_empty |=>, empty )

  // if empty is set, pre_empty must have been set in the previous clock cycle
  `AST(sfifo, pre_empty_previous_cycle_if_empty, ##1 $rose(empty) |->, $past(pre_empty) )

  // make sure that fifo was full at least once
  `COV(sfifo, full_cov, , full )

  // make sure that fifo was empty at least once
  `COV(sfifo, empty_cov, , empty )

  // make sure that fifo was pre_full at least once
  `COV(sfifo, pre_full_cov, , pre_full )

  // make sure that fifo was pre_empty at least once
  `COV(sfifo, pre_empty_cov, , pre_empty )

  // make sure that fifo was empty and then got full and then got empty again at least once
  `COV(sfifo, empty_then_full_then_empty_cov, empty |-> , ##[0:$] full |-> ##[0:$] empty )

  covergroup full_empty_cg @(posedge clk);
    option.per_instance = 1;
    full: coverpoint full ; // creates one bin when fifo is full
    empty: coverpoint empty; // creates one bin when fifo is empty
    wdata: coverpoint wdata { bins wdata_bins [] = {[0: 1<<COLS - 1]}; }
    rdata: coverpoint rdata { bins rdata_bins [] = {[0: 1<<COLS - 1]}; }
  endgroup: full_empty_cg

  full_empty_cg full_empty_cg_i = new();

endmodule: fv_sfifo

bind sfifo fv_sfifo fv_sfifo_inst(.*);
