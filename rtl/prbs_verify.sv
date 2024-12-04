module prbs_verify(
    input  logic        clk,
    input  logic        reset_N,
    input  logic        load,
    input  logic        en,
    output logic        pass
);

// ROM Inference
// const logic [1:15] seed_rom = 15'b011011100010101;
const logic [95:0] out_data_rom = 96'h558AC4A53A1724E163AC2BF9;

const logic [95:0] in_data_rom = 96'hACBCD2114DAE1577C6DBF4C9;

// Internal Signals
logic data_out;
// logic [1:96] output_sequence;
logic data_in_serial;

logic ready_fec;
logic valid_in;
logic valid_out;
logic ready_prbs;

prbs prbs_inst(.data_in(data_in_serial), .clk(clk), .reset_N(reset_N), .load(load), .en(en),
               .ready_fec(ready_fec), .valid_in(valid_in), .valid_out(valid_out),
                .ready_prbs(ready_prbs), .data_out(data_out));

logic [6:0] i; // counter
logic [6:0] error_count;
always_ff @(posedge clk or negedge reset_N) begin
    if(reset_N == 1'b0) begin
        // Reset Logic
        // output_sequence <= 96'b0;
        i <= 7'd95;
        error_count <= '0;
    end else if((en && ready_prbs) == 1'b1) begin
        
        if((i != 0)) begin
            // output_sequence <= (output_sequence << 1) | data_out;   // Shift and bit-wise or to add data_out to the output_sequence
            
            // Verify Logic
            // if(out_data_rom[i] !== data_out) begin
            //     error_count <= error_count + 1;
            //     $display("Expected: %b Got: %b", out_data_rom[i], data_out);
            //     // $display("Received: %b", data_out);
            // end

            i <= i - 1;

        end else begin
            i <= 7'd95;    // Reset to 1 when counter passes 96
        end
    end
end



logic [6:0] pass_counter;
// serialize the in_data_rom bits for the PRBS
assign data_in_serial = in_data_rom[i];

always_ff @(posedge clk or negedge reset_N) begin
    if(~reset_N) begin
        pass_counter <= 7'd95;
    end else if(valid_out) begin
        // pass_counter <= i;
            if(out_data_rom[pass_counter] !== data_out) begin
                error_count <= error_count + 1;
                // $display("Expected: %b Got: %b", out_data_rom[i], data_out);
            end

        if(pass_counter == 7'd0) begin
            pass_counter <= 7'd95;
        end else begin
            pass_counter <= pass_counter - 1;
        end

    end
end
assign valid_in = 1'b1;

// Verify Logic continued
assign pass = ((error_count === 1'b0) && (valid_out)) ? 1'b1 : 1'b0;

// always_comb begin
//     if(out_data_rom[i] == output_sequence[96]) begin
//         pass = 1;
//     end else begin
//         pass = 0;
//     end
// end

endmodule