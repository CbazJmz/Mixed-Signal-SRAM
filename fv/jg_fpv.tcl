clear -all

set_proofgrid_bridge off

analyze -sv12 ../rtl/defines.svh
analyze -sv12 ../rtl/sram_cell.sv
analyze -sv12 ../rtl/write_driver.sv
analyze -sv12 ../rtl/decoder.sv
analyze -sv12 ../rtl/sense_amp.sv
analyze -sv12 ../rtl/cell_array.sv
analyze -sv12 ../rtl/sipo.sv
analyze -sv12 ../rtl/sram_top.sv
analyze -sv12 property_defines.svh
#analyze -sv12 +define+SFIFO_TOP fv_sfifo.sv

elaborate  -bbox_a 65535 -bbox_mul 65535 -top sram_top

clock clk
reset -expression !arst_n

set_engineJ_max_trace_length 2000
