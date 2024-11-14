module PPBufferControl (
    input  logic clk,
    input  logic resetN,
    // input  logic wrdata_A,
    output logic wren_A,
    // input  logic wraddress_A,
    // input  logic rdaddress_A,
    output logic rden_A,
    input  logic q_A,

    // input  logic wrdata_B,
    output logic wren_B,
    // input  logic wraddress_B,
    // input  logic rdaddress_B,
    output logic rden_B,
    input  logic q_B,
     
    input  logic valid_prev,
    // input  logic ready_next,
    output logic q

);

logic       q_sel;

logic       bit_counter_resetN;
logic [7:0] bit_counter;
logic       count_en;

typedef enum logic [1:0] {
    IDLE,
    WRITE_A,
    WRITE_B
} BufferControlState_t;

BufferControlState_t state, state_next;

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
    case(state)
        IDLE: begin
            if(valid_prev == 1'b1) begin
                state_next = WRITE_A;
            end else begin
                state_next = IDLE;
            end
        end
        WRITE_A: begin
            if(bit_counter == 8'd191) begin
                state_next = WRITE_B;
            end else begin
                state_next = WRITE_A;
            end
        end
        WRITE_B: begin
            if(bit_counter == 8'd191) begin
                state_next = WRITE_A;
            end else begin
                state_next = WRITE_B;
            end
        end
    endcase
end

// Output logic
always_comb begin
    case(state)
        IDLE: begin
            rden_A             = 1'b0;
            rden_B             = 1'b0;
            wren_A             = 1'b0;
            wren_B             = 1'b0;
            q_sel              = 1'b0;

            bit_counter_resetN = 1'b0;
            count_en           = 1'b0;
        end
        WRITE_A: begin
            rden_A             = 1'b0;
            rden_B             = 1'b1;
            wren_A             = 1'b1;
            wren_B             = 1'b0;
            q_sel              = 1'b1;

            bit_counter_resetN = 1'b0;
            count_en           = 1'b1;
            
        end
        WRITE_B: begin
            rden_A             = 1'b1;
            rden_B             = 1'b0;
            wren_A             = 1'b0;
            wren_B             = 1'b1;
            q_sel              = 1'b0;

            bit_counter_resetN = 1'b0;
            count_en           = 1'b1;
        end
    endcase

    if (q_sel == 1'b1) begin
        q = q_B;
    end begin
        q = q_A;
    end
end

always_ff @(posedge clk or negedge bit_counter_resetN) begin
    if(bit_counter_resetN == 1'b0) begin
        bit_counter <= '0;
    end else if(count_en == 1'b1) begin

        if(bit_counter == 191) bit_counter <= '0;
        else                   bit_counter <= bit_counter + 1;

    end

end
endmodule