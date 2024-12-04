module WiMAX_PHY_top_verify_tb();

bit clk_ref;
bit reset_N;
bit load;
bit en;

bit prbs_pass;
bit fec_pass;
bit interleaver_pass;
bit modulator_pass;

WiMAX_PHY_top_verify dut (
    
    .clk_ref(clk_ref),        // Reference (50 MHz)
    .reset_N(reset_N),        // Reset (active low)
    .load(load),           // load for PRBS to load seed
    .en(en),             // enable for PRBS to start working
    // input  logic ready_in,       // Ready in from TB
    
    .prbs_pass(prbs_pass),
    .fec_pass(fec_pass),
    .interleaver_pass(interleaver_pass),
    .modulator_pass(modulator_pass)

);

endmodule