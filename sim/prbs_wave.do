onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /prbs_verify_tb/clk
add wave -noupdate /prbs_verify_tb/reset_N
add wave -noupdate /prbs_verify_tb/load
add wave -noupdate /prbs_verify_tb/en
add wave -noupdate /prbs_verify_tb/pass
add wave -noupdate /prbs_verify_tb/prbs_verify_inst/data_out
add wave -noupdate /prbs_verify_tb/prbs_verify_inst/data_in_serial
add wave -noupdate /prbs_verify_tb/prbs_verify_inst/valid_in
add wave -noupdate /prbs_verify_tb/prbs_verify_inst/valid_out
add wave -noupdate /prbs_verify_tb/prbs_verify_inst/ready_prbs
add wave -noupdate /prbs_verify_tb/prbs_verify_inst/error_count
add wave -noupdate /prbs_verify_tb/prbs_verify_inst/pass_counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {402 ps} 0}
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
WaveRestoreZoom {0 ps} {1092 ps}
