module prbsControl(
    input  logic clk,
    input  logic resetN,
    // input  logic data_in,
    input  logic ready_tb,
    input  logic valid_in,

    output logic load,
    output logic en,

    // output logic data_out,
    output logic valid_out,
    output logic ready_randomizer
);

typedef enum logic [1:0] {
    IDLE,
    LOAD,
    OUTPUT
} prbsControlState_t;

prbsControlState_t state, state_next;

// State Register
always_ff @(posedge clk or negedge resetN) begin
    if(resetN == 1'b0) begin
        state <= IDLE;
    end else begin
        state <= state_next;
    end
end

// Next State Logic
always_comb begin
    // state_next = state;
    case(state)
        IDLE: begin
            if(load == 1'b1) begin
                state_next = LOAD;
            end else begin
                state_next = IDLE;
            end
        end
        LOAD: begin
            if((en) == 1'b1) begin
                state_next = LOAD;
            end else begin
                state_next = OUTPUT;
            end
        end
        OUTPUT: begin
            if((valid_in && en) == 1'b1) begin
                state_next = OUTPUT;
            end else begin
                state_next = IDLE;
            end
        end
    endcase
end

// Output logic
always_comb begin
    case(state)
        IDLE: begin
            load = 1'b0;
            en = 1'b0;
            valid_out = 1'b0;
            ready_randomizer = 1'b1;
        end
        LOAD: begin
            load = 1'b1;
            en = 1'b0;
            valid_out = 1'b0;
            ready_randomizer = 1'b1;
        end
        OUTPUT: begin
            load = 1'b0;
            en = 1'b1;
            valid_out = 1'b1;
            ready_randomizer = 1'b1;
        end
    endcase
end



endmodule