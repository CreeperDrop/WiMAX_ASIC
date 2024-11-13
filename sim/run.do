quit -sim
vlib work
#vmap altera_mf "C:/intelFPGA_lite/22.1std/questa_fse/intel/verilog/altera_mf"

vlog -sv "../rtl/*.sv"

vlog -sv interleaver_tb.sv
vsim -voptargs=+acc work.interleaver_tb
do wave.do
run -all