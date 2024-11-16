onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /PPBuffer_tb/clk
add wave -noupdate /PPBuffer_tb/resetN
add wave -noupdate -radix unsigned /PPBuffer_tb/wraddress
add wave -noupdate /PPBuffer_tb/wrdata
add wave -noupdate /PPBuffer_tb/rdaddress
add wave -noupdate /PPBuffer_tb/q
add wave -noupdate /PPBuffer_tb/dut/q_A
add wave -noupdate /PPBuffer_tb/dut/q_B
add wave -noupdate /PPBuffer_tb/dut/rden_A
add wave -noupdate /PPBuffer_tb/dut/rden_B
add wave -noupdate /PPBuffer_tb/dut/wren_A
add wave -noupdate /PPBuffer_tb/dut/wren_B
add wave -noupdate /PPBuffer_tb/dut/BufferControl/state
add wave -noupdate /PPBuffer_tb/dut/BufferControl/q_sel
add wave -noupdate /PPBuffer_tb/dut/BufferControl/bit_counter
add wave -noupdate /PPBuffer_tb/valid_prev
add wave -noupdate /PPBuffer_tb/dut/valid_prev
add wave -noupdate /PPBuffer_tb/valid_out
add wave -noupdate /PPBuffer_tb/ready_out
add wave -noupdate /PPBuffer_tb/dut/BufferControl/clear_counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {28077 ps} 0}
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
WaveRestoreZoom {0 ps} {126239 ps}
