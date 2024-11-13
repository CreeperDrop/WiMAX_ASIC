quit -sim
vlib work
vmap altera_mf "C:/intelFPGA_lite/22.1std/questa_fse/intel/verilog/altera_mf"

vlog -sv "../rtl/FEC.sv"
vlog -sv "../ip/DPR_IP.v"

vlog -sv FEC_tb.sv
vsim -voptargs=+acc -L altera_mf work.FEC_tb
do wave.do
run -all