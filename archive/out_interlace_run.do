quit -sim
vlib work
#vmap altera_mf "C:/intelFPGA_lite/22.1std/questa_fse/intel/verilog/altera_mf"

vlog -sv "../rtl/out_interlace.sv"

vlog -sv out_interlace_tb.sv
vsim -voptargs=+acc work.out_interlace_tb

do out_interlace_wave.do
run -all