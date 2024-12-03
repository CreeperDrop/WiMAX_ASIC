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
// internal signals

logic locked;



//randomizer signals

logic randoumizer_data_out_;
logic randoumizer_valid_out;
integer randoumizer_counter;
logic randoumizer_pass_flag;

//FEC signals

logic FEC_data_out_;
logic FEC_valid_out;
integer FEC_counter;
logic FEC_pass_flag;


//Interleaver signals

logic interleaver_data_out_;
logic interleaver_valid_out;
integer interleaver_counter;
logic interleaver_pass_flag;

//Modulator signals

logic mod_data_out1;
logic mod_data_out2;
logic mod_valid_out;
integer mod_counter;
logic mod_pass_flag;


// WiMAX_PHY_top instantiation

WiMAX_PHY_top WiMAX_PHY_U0 (
    .clk_ref(clk_ref),        // Reference (50 MHz)
    .reset_N(reset_N),        // Reset (active low)
    .data_in(),        // From TB
    .load(load),           // load for PRBS to load seed
    .en(en),             // enable for PRBS to start working
    .valid_in(),       // Valid in from TB
    .ready_in(),       // Ready in from TB
    .ready_out(),      // ready from TB to modulator
    .valid_out(),      // Valid out to TB
    .pll_locked(),
    .prbs_out(),
    .prbs_valid(),
    .fec_out(),
    .fec_valid(),
    .interleaver_out(),
    .interleaver_valid(),
    .I_comp(),
    .Q_comp()
);
// WiMAX_PHY_top   wimax_U0(
//     .clk_ref(clk_ref)       
//     .reset_N(reset_N)    
//     .data_in()    
//     .load   
//     .en         
//     .valid_in()      
//     .ready_in     
//     .ready_out      
//     .valid_out    
//     .prbs_out
//     .fec_out
//     .interleaver_out
//     .I_comp
//     .Q_comp


// );


endmodule