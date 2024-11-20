quit -sim
vlib work
#vmap altera_mf "C:/intelFPGA_lite/22.1std/questa_fse/intel/verilog/altera_mf"

vlog -sv "../rtl/*.sv"

vlog -sv prbs_tb.sv
vsim -voptargs=+acc work.prbs_tb
do prbs_wave.do

run -all