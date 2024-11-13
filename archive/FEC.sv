module DPR_FEC_Encoder (
    input  logic clk_50mhz,                // 50 MHz clock input
    input  logic clk_100mhz,               // 100 MHz clock input
    input  logic reset,                    // Asynchronous reset input
    input  logic rand_out_valid,           // Valid signal for input data
    input  logic data_in,                  // Serial input data
    output logic FEC_encoder_out_valid_out, // Valid signal for output data
    output logic data_out                  // Serial output data
);

   
localparam integer BUFFER_SIZE  = 96;   // Size of the input buffer
localparam integer BUFFER_SIZE2 = 192;  // Twice the input buffer size
    //internal signals
logic [5:0] shift_reg;                   // 6-bit shift register for PingPong_flag == 1
logic [5:0] shift_reg2;                  // 6-bit shift register for PingPong_flag == 0
integer counter_buffer_input;            // Counter for buffering input data
integer counter_shift_and_output;        // Counter for shifting and outputting data
logic finished_tail_flag;                // Flag indicating tail bits have been processed
logic FEC_encoder_out_valid;             // Internal valid signal for output data
logic PingPong_flag;                     // Flag to alternate between two operations
logic finished_tail_flag_sync;           // Synchronized version of finished_tail_flag

    //state machine types
    typedef enum logic [1:0] {idle, buffer_first_input, PingPong_state} input_state_type;
    input_state_type input_state_reg;

    typedef enum logic [1:0] {idle_out, x, y} output_state_type;
    output_state_type output_state_reg;


//State Machine Definitions://

//Two state machines are defined:
//Input State Machine (input_state_type):
//idle: Waiting for input data.
//buffer_first_input: Buffering the first set of input data.
//PingPong_state: Processing data using the ping-pong mechanism.
//Output State Machine (output_state_type):
//idle_out: Waiting to output data.
//x and y: States used in the encoding process to output different sets of bits.

    //DPR signals
    logic [7:0] address_a;
    logic [7:0] address_b;
    logic clock_a;
logic clock_b;
    logic [0:0] data_a;
    logic [0:0] data_b;
    logic wren_a, rden_a;
    logic wren_b, rden_b;
    logic [0:0] q_a;
    logic [0:0] q_b;

    //DPR
    DPR_IP ram1 (
        .address_a(address_a),
        .address_b(address_b),
        .clock_a   (clk_50mhz),
 .clock_b  (clk_100mhz),
        .data_a   (data_a),
        .data_b   (data_b),
        .wren_a   (wren_a),
        .wren_b   (wren_b),
 .rden_a (rden_a),
        .rden_b (rden_b),
        .q_a      (q_a),
        .q_b      (q_b)
    );

  // Address and data assignments for RAM
    assign clock_a = clk_50mhz;  
assign clock_b = clk_100mhz;  
assign address_a = (PingPong_flag == 1'b0) ? counter_buffer_input[7:0] : (counter_buffer_input + 96);
    assign address_b = counter_shift_and_output[7:0];
    assign data_a    = data_in;
    assign wren_a    = rand_out_valid;
    assign FEC_encoder_out_valid_out = FEC_encoder_out_valid;

  always_comb begin
    // Default assignment
    data_out = 1'b0;
   
    // First level case statement based on PingPong_flag
    case (PingPong_flag)
        1'b1: begin
            // Nested case for PingPong_flag == 1
            case (output_state_reg)
                idle_out: begin
                    if (finished_tail_flag == 1'b1)
                        data_out = q_b[0] ^ shift_reg[0] ^ shift_reg[3] ^
                                  shift_reg[4] ^ shift_reg[5];
                end
               
                x: begin
                    data_out = q_b[0] ^ shift_reg[0] ^ shift_reg[3] ^
                              shift_reg[4] ^ shift_reg[5];
                end
               
                y: begin
                    data_out = q_b[0] ^ shift_reg[0] ^ shift_reg[1] ^
                              shift_reg[3] ^ shift_reg[4];
                end
               
                default: data_out = 1'b0;
            endcase
        end
       
        1'b0: begin
            // Nested case for PingPong_flag == 0
            case (output_state_reg)
                idle_out: begin
                    if (finished_tail_flag == 1'b1)
                        data_out = q_b[0] ^ shift_reg2[0] ^ shift_reg2[3] ^
                                  shift_reg2[4] ^ shift_reg2[5];
                end
               
                x: begin
                    data_out = q_b[0] ^ shift_reg2[0] ^ shift_reg2[3] ^
                              shift_reg2[4] ^ shift_reg2[5];
                end
               
                y: begin
                    data_out = q_b[0] ^ shift_reg2[0] ^ shift_reg2[1] ^
                              shift_reg2[3] ^ shift_reg2[4];
                end
               
                default: data_out = 1'b0;
            endcase
        end
       
        default: data_out = 1'b0;
    endcase
end

    assign FEC_encoder_out_valid = (input_state_reg == PingPong_state);



    //state machine 1//

 // Input State Machine (operates on clk_50mhz)
always_ff @(posedge clock_a or posedge reset) begin
    if (reset) begin
        // Reset all internal signals
        counter_buffer_input     <= 0;
        shift_reg                <= 6'b0;
        shift_reg2               <= 6'b0;
        counter_shift_and_output <= 0;
        finished_tail_flag       <= 1'b0;
        PingPong_flag            <= 1'b0;
        input_state_reg          <= idle;
    end else begin
        // State machine transitions
        case (input_state_reg)
            idle: begin
                if (rand_out_valid == 1'b1) begin
                    // Start buffering input data
                    counter_buffer_input <= counter_buffer_input + 1;
                    input_state_reg      <= buffer_first_input;
                end
            end
            buffer_first_input: begin
                if (counter_buffer_input >= 90 && counter_buffer_input <= 95) begin
                    // Load the last 6 bits into the shift register
                    shift_reg[counter_buffer_input - 90] <= data_in;
                end
                if (counter_buffer_input < BUFFER_SIZE - 1) begin
                    // Continue buffering input data
                    counter_buffer_input <= counter_buffer_input + 1;
                end else begin
                    // Buffering complete, prepare for encoding
                    counter_buffer_input     <= 0;
                    input_state_reg          <= PingPong_state;
                    finished_tail_flag       <= 1'b1;
                    counter_shift_and_output <= counter_shift_and_output + 1;
                    PingPong_flag            <= 1'b1;
                end
            end
            PingPong_state: begin
                // Handle tail bits
                if (counter_buffer_input >= 90 && counter_buffer_input <= 95) begin
                    if (PingPong_flag == 1'b0) begin
                        // Load data into shift_reg
                        shift_reg[counter_buffer_input - 90] <= data_in;
                    end else begin
                        // Load data into shift_reg2
                        shift_reg2[counter_buffer_input - 90] <= data_in;
                    end
                end
                if (counter_shift_and_output < BUFFER_SIZE && PingPong_flag == 1'b1) begin
                    // Shift and update shift_reg
                    shift_reg                <= {q_b[0], shift_reg[5:1]};
                    counter_shift_and_output <= counter_shift_and_output + 1;
                    if (counter_buffer_input < BUFFER_SIZE - 1) begin
                        counter_buffer_input <= counter_buffer_input + 1;
                    end
                end else if (counter_shift_and_output >= BUFFER_SIZE && counter_shift_and_output < BUFFER_SIZE2 && PingPong_flag == 1'b0) begin
                    // Shift and update shift_reg2
                    shift_reg2               <= {q_b[0], shift_reg2[5:1]};
                    counter_shift_and_output <= counter_shift_and_output + 1;
                    if (counter_buffer_input < BUFFER_SIZE - 1) begin
                        counter_buffer_input <= counter_buffer_input + 1;
                    end
                end else if (counter_shift_and_output == BUFFER_SIZE2) begin
                    // Completed processing, reset counters
                    counter_shift_and_output <= 0;
                    counter_buffer_input     <= counter_buffer_input + 1;
                end
                if (rand_out_valid == 1'b0 && (counter_shift_and_output == 96 || counter_shift_and_output == 192)) begin
                    // No more input data, return to idle state
                    counter_shift_and_output <= 0;
                    input_state_reg          <= idle;
                end
                if (counter_buffer_input == BUFFER_SIZE - 1) begin
                    // Switch PingPong_flag and reset buffer input counter
                    PingPong_flag        <= ~PingPong_flag;
                    counter_buffer_input <= 0;
                    if (counter_shift_and_output < BUFFER_SIZE2 - 1) begin
                        counter_shift_and_output <= counter_shift_and_output + 1;
                    end else begin
                        counter_shift_and_output <= 0;
                    end
                end
                if (counter_shift_and_output == 191) begin
                    // Reset counter at the end of processing
                    counter_shift_and_output <= 0;
                end
            end
        endcase
    end
end


//synchronizer
// Synchronize finished_tail_flag to clk_100mhz domain
always_ff @(posedge clock_b or posedge reset) begin
    if (reset) begin
        finished_tail_flag_sync <= 1'b0;
    end else begin
        finished_tail_flag_sync <= finished_tail_flag;
    end
end


// Output State Machine (operates on clk_100mhz)
always_ff @(posedge clk_100mhz or posedge reset) begin
    if (reset) begin
        output_state_reg <= idle_out;
    end else if (finished_tail_flag_sync == 1'b1) begin
        // State machine transitions
        case (output_state_reg)
            idle_out: begin
                if (counter_shift_and_output == 1) begin
                    output_state_reg <= 0;
                end
            end
            x: begin
                if (counter_shift_and_output <= BUFFER_SIZE2 && FEC_encoder_out_valid == 1'b1) begin
                    output_state_reg <= x;
                end
            end
            y: begin
                if (FEC_encoder_out_valid == 1'b0 && (counter_shift_and_output == BUFFER_SIZE + 1 || counter_shift_and_output == BUFFER_SIZE2 + 1)) begin
                    // No more valid data, return to idle state
                    output_state_reg <= idle_out;
                end else if ((counter_shift_and_output < BUFFER_SIZE2) && FEC_encoder_out_valid == 1'b1) begin
                    // Continue encoding
                    output_state_reg <= y;
                end
            end
        endcase
    end
end

endmodule