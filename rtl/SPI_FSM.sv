module SPI_FSM #(
    parameter PARALLEL_WIDTH = 96
)(
    input  logic clk,
    input  logic resetN,
    input  logic serial_ready,
    input  logic serial_in,
    
    output logic parallel_ready,
    output logic [PARALLEL_WIDTH-1:0] parallel_out
);

typedef enum logic [2:0] { 
    IDLE    = 3'b001,
    COLLECT = 3'b010,
    DONE    = 3'b100
} SPI_state_t;

SPI_state_t state;
SPI_state_t state_next;

logic [$clog2(PARALLEL_WIDTH)-1:0] bit_counter;
logic                              bit_counter_resetN;
logic                              shift_en;

// State Register
always_ff @(posedge clk or negedge resetN) begin
    if(resetN == 1'b0) begin
        state <= IDLE;
    end else begin
        state <= state_next;
    end
end

// Next state Logic
always_comb begin
    case(state)
        IDLE: begin
           if(serial_ready == 1'b0)  state_next = IDLE;
           else                      state_next = COLLECT; 
        end
        COLLECT: begin
            if(bit_counter != '0)    state_next = COLLECT;
            else                     state_next = DONE;
        end
        DONE: begin
            if(serial_ready == 1'b1) state_next = COLLECT;
            else                     state_next = IDLE;
        end
    endcase
end

// Output Logic
always_comb begin
    case(state)
        IDLE: begin
            bit_counter_resetN = 1'b0;
            parallel_ready     = 1'b0;
            shift_en           = 1'b0;
        end
        COLLECT: begin
            bit_counter_resetN = 1'b1;
            parallel_ready     = 1'b0;
            shift_en           = 1'b1;
        end
        DONE:   begin
            bit_counter_resetN = 1'b0;
            parallel_ready     = 1'b1;
            shift_en           = 1'b0;

        end
    endcase
end

// Parallel Out Shift Reg
always_ff @(posedge clk or negedge resetN) begin
    if(resetN == 1'b0) begin
        parallel_out <= '0;
    end else if(shift_en == 1'b1)begin
        parallel_out <= {serial_in, parallel_out[PARALLEL_WIDTH-1:1]};
    end
end

// CountDown
always_ff @(posedge clk or negedge bit_counter_resetN) begin
    if(bit_counter_resetN == 1'b0) begin
        bit_counter <= PARALLEL_WIDTH-1;
    end else begin
        bit_counter <= bit_counter - 1;
    end
end

endmodule