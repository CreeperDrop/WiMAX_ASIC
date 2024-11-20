module prbs(
    input  logic        data_in,
    input  logic        clk,
    input  logic        reset,
    input  logic        load,
    input  logic        en,
    input  logic [1:15] seed,
    input  logic        ready_fec, // Ready from FEC
    input  logic        valid_in,  // Valid from testbench
    output logic        data_out,  // Data out from randomizer
    output logic        valid_out, // Valid out from randomizer
    output logic        ready_randomizer    // Ready out from randomizer
    
);
    logic [1:15] r_reg;
    logic [1:15] r_next;

    logic lfsrXOR;

    // Init with: 15'b011011100010101

    // Register inference 
    always_ff @(posedge clk or negedge reset)
    begin
        // if(reset == 1'b1) 
        // begin
        //     r_reg <= '0;
        // end
        // else if(load == 1'b1)
        // begin
        //     r_reg <= seed;
        // end
        // else if(en == 1'b1)
        // begin
        //     r_reg <= r_next;

        // end
        case(1'b1)
            ~reset: begin
                r_reg <= '0;
                ready_randomizer <= 1'b0;
            end
            load:  begin
                r_reg <= seed;
                ready_randomizer <= 1'b1;
            end
            (en && valid_in): begin
                r_reg <= r_next;
                ready_randomizer <= 1'b1;
            end
        endcase

    end

    always_comb
    begin
        lfsrXOR = r_reg[15] ^ r_reg[14];
        // Next state logic
        r_next = {lfsrXOR, r_reg[1:14]};

        // Output logic
        data_out = en ? (data_in ^ lfsrXOR) : 1'bx;

        valid_out = en & ready_fec;
    end


endmodule