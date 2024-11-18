onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /interleaver_top_tb/clk
add wave -noupdate /interleaver_top_tb/resetN
add wave -noupdate /interleaver_top_tb/valid_fec
add wave -noupdate -color Cyan /interleaver_top_tb/data_in
add wave -noupdate /interleaver_top_tb/data_out
add wave -noupdate /interleaver_top_tb/ready_in
add wave -noupdate /interleaver_top_tb/ready_interleaver
add wave -noupdate /interleaver_top_tb/valid_interleaver
add wave -noupdate /interleaver_top_tb/predicted_out
add wave -noupdate /interleaver_top_tb/data_in_sequence
add wave -noupdate /interleaver_top_tb/dut/data_out_index
add wave -noupdate /interleaver_top_tb/dut/rdaddress
add wave -noupdate /interleaver_top_tb/dut/PingPongBuffer_inst/BufferControl/state
add wave -noupdate /interleaver_top_tb/dut/valid_out
add wave -noupdate /interleaver_top_tb/dut/Interleaver_inst/data_out_index
add wave -noupdate /interleaver_top_tb/dut/Interleaver_inst/data_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2948022731 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {3383600 ps} {3895600 ps}
