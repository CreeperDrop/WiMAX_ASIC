import Package_wimax::*; 

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

// ROMs
const logic [95:0]  PRBS_INPUT         = RANDOMIZER_INPUT;
const logic [95:0]  PRBS_OUTPUT        = RANDOMIZER_OUTPUT;
const logic [191:0] FEC_ENCODER_OUTPUT = FEC_ENDODER_OUTPUT;
const logic [191:0] INTERLEAVER_OUTPUT = INTERLEAVER_OUTPUT;
const logic [1:0]   MOD_OUTPUT [0:95]  = MOD_OUTPUT; // (1 -> I, 0 -> Q) => {I, Q}

// internal signals

// PLL signals
logic clk_50;
logic clk_100;
logic pll_locked;


//randomizer signals
logic randomizer_data_in;
logic randomizer_valid_in;
logic randomizer_ready_out;
logic randomizer_in_counter;
logic randomizer_data_out;
logic randomizer_valid_out;
integer randomizer_out_counter;
integer randomizer_out_error_count;
// logic randoumizer_pass_flag;

//FEC signals

logic FEC_data_out;
logic FEC_valid_out;
integer FEC_counter;
integer FEC_out_error_count;
// logic FEC_pass_flag;


//Interleaver signals

logic interleaver_data_out;
logic interleaver_valid_out;
integer interleaver_counter;
integer interleaver_out_error_count;
// logic interleaver_pass_flag;

//Modulator signals

logic mod_ready_in;
logic mod_I_comp;
logic mod_Q_comp;
logic mod_valid_out;
integer mod_counter;
integer mod_out_error_count;
// integer mod_out_error_count;
// logic mod_pass_flag;


// WiMAX_PHY_top instantiation

WiMAX_PHY_top WiMAX_PHY_U0 (
    .clk_ref(clk_ref),        // Reference (50 MHz)
    .reset_N(reset_N),        // Reset (active low)
    .data_in(randomizer_data_in),        // From Verify
    .load(load),           // load for PRBS to load seed
    .en(en),             // enable for PRBS to start working
    .valid_in(randomizer_valid_in),       // Valid in from Verify
    .ready_in(mod_ready_in),       // Ready in from Verify
    .ready_out(randomizer_ready_out),      // ready from PRBS to Verify
    .valid_out(mod_valid_out),      // Valid out to TB
    .clk_50(clk_50),         // 50 MHz clock
    .clk_100(clk_100),        // 100 MHz clock
    .locked(pll_locked),
    .prbs_out(randomizer_data_out),
    .prbs_valid(randomizer_valid_out),
    .fec_out(FEC_data_out),
    .fec_valid(FEC_valid_out),
    .interleaver_out(interleaver_data_out),
    .interleaver_valid(interleaver_valid_out),
    .I_comp(mod_I_comp),
    .Q_comp(mod_Q_comp)
);

// PRBS input serialization
always_ff @(posedge clk_50 or negedge reset_N) begin
    if (~reset_N) begin
        randomizer_valid_in <= 1'b0;
        randomizer_in_counter <= 7'd95;
    end
    else if(randomizer_ready_out) begin

        if (randomizer_in_counter == '0) begin
            randomizer_in_counter <= 7'd95;
        end else begin
            randomizer_valid_in <= 1'b1;
            randomizer_in_counter <= randomizer_in_counter - 1;
        end

    end
end

assign randomizer_data_in = PRBS_INPUT[randomizer_in_counter];

// PRBS output check
always_ff @(posedge clk_50 or negedge reset_N) begin
    if (~reset_N) begin
        randomizer_out_counter <= 7'd95;
        randomizer_out_error_count <= '0;
    end else begin
        if (randomizer_valid_out) begin
            if (randomizer_data_out != PRBS_OUTPUT[randomizer_out_counter]) begin
                randomizer_out_error_count <= randomizer_out_error_count + 1;
            end

            if(randomizer_out_counter == '0) begin
                randomizer_out_counter <= 7'd95;
            end else begin
                randomizer_out_counter <= randomizer_out_counter - 1;
            end
        end
    end
end

assign prbs_pass = (randomizer_out_error_count == 1'b0) /*? 1'b1 : 1'b0*/ ;

// FEC output check

always_ff @(posedge clk_100 or negedge reset_N) begin
    if (~reset_N) begin
        FEC_counter <= 7'd191;
        FEC_out_error_count <= '0;
    end else begin
        if (FEC_valid_out) begin
            if (FEC_data_out != FEC_ENCODER_OUTPUT[FEC_counter]) begin
                FEC_out_error_count <= FEC_out_error_count + 1;
            end

            if(FEC_counter == '0) begin
                FEC_counter <= 7'd191;
            end else begin
                FEC_counter <= FEC_counter - 1;
            end
        end
    end
end

assign fec_pass = (FEC_out_error_count == 1'b0) /*? 1'b1 : 1'b0*/ ;

// Interleaver output check

always_ff @(posedge clk_100 or negedge reset_N) begin
    if (~reset_N) begin
        interleaver_counter <= 7'd191;
        interleaver_out_error_count <= '0;
    end else begin
        if (interleaver_valid_out) begin
            if (interleaver_data_out != INTERLEAVER_OUTPUT[interleaver_counter]) begin
                interleaver_out_error_count <= interleaver_out_error_count + 1;
            end

            if(interleaver_counter == '0) begin
                interleaver_counter <= 7'd191;
            end else begin
                interleaver_counter <= interleaver_counter - 1;
            end
        end
    end
end

assign interleaver_pass = (interleaver_out_error_count == 1'b0) /*? 1'b1 : 1'b0*/ ;


// Modulator output check

always_ff @(posedge clk_100 or negedge reset_N) begin
    if (~reset_N) begin
        mod_counter <= '0;
        mod_out_error_count <= '0;
    end else begin
        if (mod_valid_out) begin
            if ({mod_I_comp[15], mod_Q_comp[15]} != MOD_OUTPUT[mod_counter]) begin
                mod_out_error_count <= mod_out_error_count + 1;
            end

            if(mod_counter == 7'd95) begin
                mod_counter <= '0;
            end else begin
                mod_counter <= mod_counter + 1;
            end
        end
    end
end

assign modulator_pass = (mod_out_error_count == 1'b0) /*? 1'b1 : 1'b0*/ ;

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