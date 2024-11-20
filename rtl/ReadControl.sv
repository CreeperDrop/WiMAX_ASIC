module ReadControl(
    input  logic       clk,
    input  logic       resetN,
    input  logic       valid_out,
    input  logic       ready_out,
    output logic [7:0] rdaddress
);

typedef enum logic [1:0] {
    IDLE,
    READ_A,
    READ_B
} ReadControlState_t;

ReadControlState_t state, state_next;

logic [8:0] address_counter;
logic       count_en;

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
            if(valid_out == 1'b1) begin
                state_next = READ_A;
            end else begin
                state_next = IDLE;
            end
        end
        
        READ_A: begin
            if(address_counter == 191) begin
                state_next = READ_B;
            end else begin
                state_next = READ_A;
            end
        end

        READ_B: begin
            if(address_counter == 191) begin
                state_next = READ_A;
            end else begin
                state_next = READ_B;
            end
        end

        default: begin
            state_next = IDLE;
        end
    endcase
end

// Output logic
always_comb begin
    case(state)
        IDLE: begin
            rdaddress = '0;
            count_en = 0;
        end

        READ_A: begin
            rdaddress = address_counter;
            count_en = 1;
        end

        READ_B: begin
            rdaddress = address_counter;
            count_en = 1;
        end
    endcase
end

// Counter: Increment immediately when valid_out is asserted
always_ff @(posedge clk or negedge resetN) begin
    if(resetN == 1'b0) begin
        address_counter <= '0;
    end else if(ready_out == 1'b1) begin
        if(address_counter == 8'd191) begin
            address_counter <= '0;  // Reset to 0 when max value reached
        end else begin
            address_counter <= address_counter + 1;
        end
    end
end

endmodule
