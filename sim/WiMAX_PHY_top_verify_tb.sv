import Package_wimax::*; 
`timescale 1ns / 1ps

module WiMAX_PHY_top_verify_tb();

bit clk_ref;
bit reset_N;
bit load;
bit en;

bit prbs_pass;
bit fec_pass;
bit interleaver_pass;
bit modulator_pass;


initial begin
    clk_ref = 1;
    forever begin
        #CLK_50_HALF_PERIOD clk_ref = ~clk_ref;
    end
end

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

initial begin
    // Reset sequence
    
    reset_N = 0;
    #(CLK_50_PERIOD);
    reset_N = 1;
       
    wait(dut.pll_locked == 1'b1);
    // dut.randomizer_ready_out = 1;
    // #(1*CLK_50_PERIOD);
    // Load sequence
    load = 1; // for PRBS to load seed
    #(1*CLK_50_PERIOD);
    load = 0;

    // #(1*CLK_50_PERIOD);
    
    // Enable sequence
    en = 1; // for PRBS to start working
    // #(1*CLK_50_PERIOD);
    // en = 0;

    #25_000;
    $stop();
    
    
end

endmodule