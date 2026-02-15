module fv_sram (
	input logic clk,
	input logic arst_n,
	input logic [$clog2(ROWS)-1:0]addr,
	// Writing port //
	input logic w_en,
	input logic serial_in,
	input logic shift,
	input logic load,
	// Reading port //
	input logic r_en,
	output logic data_valid,
	output logic [COLS-1:0]data_out
);

  // NDCs //
  logic [$clog2(ROWS)-1:0] ptr_ndc;
  logic [$clog2(ROWS):0] tb_num_entries;
 
  asm_ndc_stable: assume property (@(posedge clk) $stable(ptr_ndc));

  // TB signals //
  logic [COLS-1:0] tb_wr_data;
  logic tb_wr_data_vd;
  logic [COLS-1:0] tb_rd_data;
  logic tb_rd_data_vd;

	logic [COLS-1:0] shift_reg;		//Shift register declaration
	logic [COLS-1:0] parallel_out;

	always_ff@(posedge clk, negedge arst_n) begin
		if(!arst_n) begin
			shift_reg <= '0;		//Reset clear the shift register
		end else begin
			if(shift)				//When shift, capture the serial_in value
				shift_reg <= {shift_reg, serial_in};
			else if(load)			//When load, show the shift register in the output
				parallel_out <= shift_reg;
		end
	end

  always_ff@(posedge clk, negedge arst_n) begin
    if(~arst_n) begin
      tb_wr_data <= 'd0;
      tb_wr_data_vd <= 1'b0;
    end else begin
      if(w_en && (~tb_wr_data_vd) && (addr == ptr_ndc)) begin
        tb_wr_data_vd <= 1'b1;
        tb_wr_data <= parallel_out;
      end
    end
  end

  always_ff@(posedge clk, negedge arst_n) begin
    if(~arst_n) begin
      tb_rd_data <= 'd0;
      tb_rd_data_vd <= 1'b0;
    end else begin
      if(r_en && (~tb_rd_data_vd)&& (addr == ptr_ndc)) begin
        tb_rd_data_vd <= 1'b1;
        tb_rd_data <= data_out;
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

  // a word is writed
  `AST(sram_top, write_word, 1'b1 |->, (tb_wr_data == data_out && w_en && addr == ptr_ndc) )
  
  // a word is readed succesfully
  `AST(sram_top, read_word, (tb_wr_data == data_out && w_en && addr == ptr_ndc) |-> ##[0:$], (tb_rd_data == data_out && ~(w_en && addr == ptr_ndc) && r_en && addr == ptr_ndc) )


endmodule: fv_sram

bind sram_top fv_sram fv_sram_inst(.*);
