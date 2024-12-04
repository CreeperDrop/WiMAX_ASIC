onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /WiMAX_PHY_top_verify_tb/clk_ref
add wave -noupdate /WiMAX_PHY_top_verify_tb/reset_N
add wave -noupdate /WiMAX_PHY_top_verify_tb/load
add wave -noupdate /WiMAX_PHY_top_verify_tb/en
add wave -noupdate /WiMAX_PHY_top_verify_tb/prbs_pass
add wave -noupdate /WiMAX_PHY_top_verify_tb/fec_pass
add wave -noupdate /WiMAX_PHY_top_verify_tb/interleaver_pass
add wave -noupdate /WiMAX_PHY_top_verify_tb/modulator_pass
add wave -noupdate -divider TESTING
add wave -noupdate /WiMAX_PHY_top_verify_tb/dut/clk_50
add wave -noupdate /WiMAX_PHY_top_verify_tb/dut/clk_100
add wave -noupdate /WiMAX_PHY_top_verify_tb/dut/pll_locked
add wave -noupdate /WiMAX_PHY_top_verify_tb/dut/randomizer_valid_out
add wave -noupdate /WiMAX_PHY_top_verify_tb/dut/FEC_valid_out
add wave -noupdate /WiMAX_PHY_top_verify_tb/dut/interleaver_valid_out
add wave -noupdate /WiMAX_PHY_top_verify_tb/dut/mod_valid_out
add wave -noupdate /WiMAX_PHY_top_verify_tb/dut/randomizer_out_counter
add wave -noupdate /WiMAX_PHY_top_verify_tb/dut/randomizer_out_error_count
add wave -noupdate /WiMAX_PHY_top_verify_tb/dut/FEC_counter
add wave -noupdate /WiMAX_PHY_top_verify_tb/dut/FEC_out_error_count
add wave -noupdate /WiMAX_PHY_top_verify_tb/dut/interleaver_counter
add wave -noupdate /WiMAX_PHY_top_verify_tb/dut/interleaver_out_error_count
add wave -noupdate /WiMAX_PHY_top_verify_tb/dut/mod_out_error_count
add wave -noupdate /WiMAX_PHY_top_verify_tb/dut/WiMAX_PHY_U0/valid_out
add wave -noupdate /WiMAX_PHY_top_verify_tb/dut/randomizer_data_in
add wave -noupdate /WiMAX_PHY_top_verify_tb/dut/randomizer_data_out
add wave -noupdate /WiMAX_PHY_top_verify_tb/dut/FEC_data_out
add wave -noupdate /WiMAX_PHY_top_verify_tb/dut/interleaver_data_out
add wave -noupdate -radix decimal /WiMAX_PHY_top_verify_tb/dut/mod_I_comp
add wave -noupdate -radix decimal /WiMAX_PHY_top_verify_tb/dut/mod_Q_comp
add wave -noupdate /WiMAX_PHY_top_verify_tb/dut/randomizer_ready_out
add wave -noupdate /WiMAX_PHY_top_verify_tb/dut/WiMAX_PHY_U0/ready_interleaver
add wave -noupdate /WiMAX_PHY_top_verify_tb/dut/WiMAX_PHY_U0/randomizer_U0/r_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {23494785 ps} 0}
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
WaveRestoreZoom {23494785 ps} {24160833 ps}
