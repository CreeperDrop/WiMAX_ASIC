onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /interleaver_tb/clk
add wave -noupdate /interleaver_tb/resetN
add wave -noupdate /interleaver_tb/data_in
add wave -noupdate /interleaver_tb/data_out
add wave -noupdate /interleaver_tb/valid_fec
add wave -noupdate /interleaver_tb/ready_interleaver
add wave -noupdate /interleaver_tb/valid_interleaver
add wave -noupdate /interleaver_tb/ready_buffer
add wave -noupdate /interleaver_tb/dut/j
add wave -noupdate /interleaver_tb/dut/k
add wave -noupdate /interleaver_tb/dut/m
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6142 ps} 0}
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
configure wave -timelineunits ns
update
WaveRestoreZoom {19150625 ps} {19213125 ps}
