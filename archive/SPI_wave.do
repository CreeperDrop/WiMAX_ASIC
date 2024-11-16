onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /SPI_FSM_tb/clk
add wave -noupdate /SPI_FSM_tb/resetN
add wave -noupdate /SPI_FSM_tb/serial_ready
add wave -noupdate /SPI_FSM_tb/serial_in
add wave -noupdate /SPI_FSM_tb/parallel_ready
add wave -noupdate /SPI_FSM_tb/parallel_out
add wave -noupdate /SPI_FSM_tb/dut/bit_counter
add wave -noupdate /SPI_FSM_tb/dut/bit_counter_resetN
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
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
WaveRestoreZoom {0 ns} {1 us}
