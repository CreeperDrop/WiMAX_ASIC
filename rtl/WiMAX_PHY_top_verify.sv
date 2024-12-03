module WiMAX_PHY_top_verify(
    input  logic clk_ref,        // Reference (50 MHz)
    input  logic reset_N,        // Reset (active low)
    input  logic load,           // load for PRBS to load seed
    input  logic en,             // enable for PRBS to start working
    // input  logic ready_in,       // Ready in from TB
    
    output logic prbs_pass,
    output logic fec_pass,
    output logic interleaver_pass,
    output logic modulator_pass

);

endmodule