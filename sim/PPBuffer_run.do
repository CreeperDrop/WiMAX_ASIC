quit -sim
vlib work
vmap altera_mf "C:/intelFPGA_lite/22.1std/questa_fse/intel/verilog/altera_mf"

vlog -sv "../rtl/*.sv"
vlog -sv "../ip/SDPR.v"

vlog -sv PPBuffer_tb.sv
vsim -voptargs=+acc -L altera_mf work.PPBuffer_tb
do PPBuffer_wave.do
run -all