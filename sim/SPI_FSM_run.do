quit -sim
vlib work
#vmap altera_mf "C:/intelFPGA_lite/22.1std/questa_fse/intel/verilog/altera_mf"

vlog -sv "../rtl/SPI_FSM.sv"

vlog -sv SPI_FSM_tb.sv
vsim -voptargs=+acc work.SPI_FSM_tb

do SPI_wave.do
run -all