src=sram
testname=test
verbosity=UVM_MEDIUM
.DEFAULT_GOAL := help

compile_switches = -f list.f -l ${logs}/comp.log -access +rwc -timescale 1ns/1ps -sv


list:
	@echo "# rtl" > list.f
	@test -f ../rtl/${src}.sv && echo "../rtl/${src}.sv" >> list.f
	@echo "# verification" >> list.f
	@echo "../verif/${src}_tb.sv" >> list.f
	
sim: 
	xrun ${compile_switches}
simvision:
	simvision shm_db


clean:
	rm -rf xrun* waves* xcelium* logs shm_db .sim* .svm* *.diag uvm_test_name.svh
