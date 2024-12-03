import Package_wimax::*; // Import the package

module WiMAX_PHY_top(
    input  logic        clk_ref,        // Reference (50 MHz)
    input  logic        reset_N,        // Reset (active low)
    input  logic        data_in,        // From TB
    input  logic        load,           // load for PRBS to load seed
    input  logic        en,             // enable for PRBS to start working
    input  logic        valid_in,       // Valid in from TB
    input  logic        ready_in,       // Ready in from TB
    
    output logic        ready_out,      // ready from TB to modulator
    output logic        valid_out,      // Valid out to TB
    output logic [15:0] I_comp,
    output logic [15:0] Q_comp
);

// PLL Wires
logic clk_50;
logic clk_100;
logic locked;

logic ready_fec;
logic valid_fec;

// PRBS Wires 
logic ready_in_fec;
logic valid_out_to_fec;
logic data_out_to_fec;


// FEC Wires (Hammad)
logic valid_out_fec;
logic data_out_fec;

// Interleaver Wires (FIZO)
logic valid_out_interleaver;
logic ready_out_interleaver;
logic data_out_interleaver;

// logic data_out_index;

// Modulator Wires (bolla)
// logic valid_interleaver; // Valid input from interleaver -->
logic ready_TOP_TB;      // input coming from top module test bench <--
logic ready_interleaver; // output ready to interleaver <--
logic valid_TOP_TB;     // output going to top module test bench -->

PLL_50_100 PLL_inst(
    .refclk(clk_ref),   //  refclk.clk
    .rst(~reset_N),      //   reset.reset
    .outclk_0(clk_50), // outclk0.clk
    .outclk_1(clk_100), // outclk1.clk
    .locked(locked)    //  locked.export
);


prbs randomizer_U0(
    .data_in(data_in),          // data in to PRBS
    .clk(clk_50),               // 50Mhz Clock
    .reset_N(reset_N),          // Reset (active low)
    .load(load),                // to load seed (15 bits) in the PRBS register
    .en(en),                    // enable to start PRBS
    .ready_fec(ready_in_fec),      // Ready coming from FEC to make PRBS start sending data 
    .valid_in(valid_in),        // valid input coming from TB (set as 1)
    .valid_out(valid_out_to_fec),      // Valid out sent to FEC to ensure data is correct
    .ready_prbs(ready_out),      // ready from PRBS sent to TB to take in data (set to 1)
    .data_out(data_out_to_fec)
);


fec_encoder_wimax_phy fec_encoder_U1(
    .clk_50(clk_50),
    .clk_100(clk_100),
    .reset_N(reset_N),
    .randomizer_output_valid(valid_out_to_fec),
    .ready_in(ready_out_interleaver),
    .data_in(data_out_to_fec),
    .valid_out(valid_out_fec),
    .ready_out(ready_in_fec),
    .data_out(data_out_fec)
);

interleaver_top interleaver_U2(
    .clk(clk_100),                             // 100Mhz clock
    .reset_N(reset_N),                         // Reset (active low)
    .valid_in(valid_out_fec),                  // valid input coming from FEC
    .ready_in(ready_interleaver),              // input ready coming from modulator
    .data_in(data_out_fec),                    // data coming in serially from FEC
    .valid_out(valid_out_interleaver),         // output valid going to modulator
    .ready_out(ready_out_interleaver),         // ready going to FEC
    .data_out(data_out_interleaver)            // data going out to modulator
);

qpsk_MOD qpsk_MOD_U3(
    .Reset_N(reset_N),                          // Reset (active low)
    .clk_100(clk_100),                          // 100Mhz clock
    // .clk_50(clk_50),                            // 50Mhz clock
    .valid_in(valid_out_interleaver),           // valid input coming from interleaver
    .ready_in(ready_in),                        // input ready coming from top module TB
    .data_in(data_out_interleaver),             // data coming in serially from interleaver
    .valid_out(valid_out),                      // output valid going to top module TB
    .I_comp(I_comp),                            // output of Modulator (16 bits) to represent I component
    .Q_comp(Q_comp),                            // output of Modulator (16 bits) to represent Q component
    .ready_out(ready_interleaver)               // output ready going to interleaver
);


endmodule