module prbs(
    input  logic        data_in,
    input  logic        clk,
    input  logic        reset,
    input  logic        load,
    input  logic        en,
    input  logic [1:15] seed,
    input  logic        ready_fec,  // Ready in from FEC
    input  logic        valid_in,   // Valid in from TB
    output logic        valid_out,  // Valid out to FEC
    output logic        ready_prbs, // Ready out to TB
    output logic        data_out
);
    logic [1:15] r_reg;
    logic [1:15] r_next;

    logic lfsrXOR;
    // Init with: 15'b011011100010101

    // Register inference 
    always_ff @(posedge clk or posedge reset)
    begin
        if(reset == 1'b1) 
        begin
            r_reg <= '0;
            ready_prbs <= 1'b0;
            valid_out <= 1'b0;
        end
        else if(load == 1'b1)
        begin
            r_reg <= seed;
            ready_prbs <= 1'b1;
            valid_out <= 1'b1;
        end
        else if((en && ready_fec && valid_in) == 1'b1)
        begin
            r_reg <= r_next;
            ready_prbs <= 1'b1;
            valid_out <= 1'b1;
        end

    end

    always_comb
    begin
        lfsrXOR = r_reg[15] ^ r_reg[14];
        // Next state logic
        r_next = {lfsrXOR, r_reg[1:14]};

        // Output logic
        data_out = data_in ^ lfsrXOR;
    end

endmodule