import Package_wimax::*;
module WiMAX_PHY_top_tb();
    timeunit 1ns;
    timeprecision 1ps;

    bit clk_ref;
    bit reset_N;
    bit data_in;
    bit load;
    bit en;
    bit valid_in;
    bit ready_in;

    bit ready_out;
    bit valid_out;
    
    bit signed [15:0] I_comp;
    bit signed [15:0] Q_comp;

    bit signed [15:0] I;
    bit signed [15:0] Q;

    

    integer i = 95;

    WiMAX_PHY_top dut(
        .clk_ref(clk_ref),          // Reference (50 MHz)
        .reset_N(reset_N),          // Reset (active low)
        .data_in(data_in),          // From TB
        .load(load),                // load for PRBS to load seed
        .en(en),                    // enable for PRBS to start working
        .valid_in(valid_in),        // Valid in from TB
        .ready_in(ready_in),        // Ready in from TB
        
        .ready_out(ready_out),      // ready from TB to modulator
        .valid_out(valid_out),      // Valid out to TB
        .I_comp(I_comp),
        .Q_comp(Q_comp)
    );

    // Clock gen
    initial begin
        clk_ref = 1;
        forever begin
            #CLK_50_HALF_PERIOD clk_ref = ~clk_ref;
        end
    end

    initial begin
        // Reset sequence
        
        reset_N = 0;
        #(CLK_50_PERIOD);
        reset_N = 1;
        
        wait(dut.locked == 1'b1);
        
        // Load sequence
        load = 1; // for PRBS to load seed
        #(1*CLK_50_PERIOD);
        // #CLK_50_HALF_PERIOD;
        load = 0; // disable load

        ready_in = 1; // ready in coming from FEC

        // Enable sequence
        en = 1;         // enable the PRBS to start working
        valid_in = 1;   // valid in from TB
        // #(CLK_50_PERIOD);
        // enter_96_inputs(0, 95, RANDOMIZER_INPUT, data_in);

        // wait(valid_out == 1);
        // repeat(5*96) begin
        //     @(posedge dut.clk_50);
        //     $display("Iout = %d, Qout = %d", I_comp, Q_comp);  
        // end
        // #(100 * CLK_50_PERIOD);
        #25000;
        $finish;
    end

    
    always @(posedge dut.clk_50 or negedge reset_N) begin
    if(!reset_N) begin 
        i <= 95;
    end else if(ready_out) begin
    //$display("Applying bit %0d: %b", i, data_in); 
        if(i == 0) begin
            i <= 95;
    // counter_output <= 0;
    end else begin
        i <= i - 1;
            end
        end
    end

    assign data_in = RANDOMIZER_INPUT[i];

    // always @(posedge dut.clk_100) begin
    //     // if((dut.qpsk_MOD_U3.bit_count == 1'b1) && (dut.qpsk_MOD_U3.valid_in == 1'b1)) begin
    //     if(valid_out == 1'b1) begin
    //         verification_I_Q(dut.qpsk_MOD_U3.b0, dut.qpsk_MOD_U3.data_in, I, Q);  
    //             billy <= 0;
    //             if (I == I_comp && Q == Q_comp) begin
    //                 $display("Test Passed!  expected: %d %d and got : %d %d at %d", I_comp, Q_comp, I, Q,billy);
    //             end else begin
    //                 $display("Test failed!  expected: %d %d and got : %d %d at %d", I_comp, Q_comp, I, Q,billy);
    //             end
    //             billy <= billy + 1'd1;
    //      end
    // end

integer rand_i = 95;
logic [95:0] rand_out;
always @(posedge dut.clk_50 or negedge reset_N) begin
    if(reset_N == 1'b0) begin
        rand_i = 95;
    end else begin
        if(dut.randomizer_U0.valid_out) begin
            rand_out[rand_i] = dut.randomizer_U0.data_out;
            if(rand_i == 0) begin
                $display("RANDOMIZER: ");
                checkOutput96(rand_out, RANDOMIZER_OUTPUT);
                rand_i = 95;
            end else begin
                rand_i = rand_i - 1;
            end
        end
    end
end

integer fec_i = 191;
logic [191:0] fec_out;
always @(posedge dut.clk_100 or negedge reset_N) begin
    if(reset_N == 1'b0) begin
        fec_i = 191;
    end else begin
        if(dut.fec_encoder_U1.valid_out) begin
            fec_out[fec_i] = dut.fec_encoder_U1.data_out;
            if(fec_i == 0) begin
                $display("FEC: ");
                checkOutput192(fec_out, FEC_ENDODER_OUTPUT);
                fec_i = 191;
            end else begin
                fec_i = fec_i - 1;
            end
        end
    end
end

integer inter_i = 191;
logic [191:0] inter_out;
always @(posedge dut.clk_100 or negedge reset_N) begin
    if(reset_N == 1'b0) begin
        inter_i = 191;
    end else begin
        if(dut.interleaver_U2.valid_out) begin
            inter_out[inter_i] = dut.interleaver_U2.data_out;
            if(inter_i == 0) begin
                $display("Interleaver: ");
                checkOutput192(inter_out, INTERLEAVER_OUTPUT);
                inter_i = 191;
            end else begin
                inter_i = inter_i - 1;
            end
        end
    end
end

integer mod_i = 0;
logic [1:0] mod_out [0:95];
always @(posedge dut.clk_100 or negedge reset_N) begin
    if(reset_N == 1'b0) begin
        mod_i = 0;
    end else begin
        if(dut.qpsk_MOD_U3.valid_out) begin
            mod_out[mod_i] = {I_comp[15], Q_comp[15]};
            if(mod_i == 191) begin
                $display("Modulator: ");
                checkModOutput(mod_out, MOD_OUTPUT);
                mod_i = 0;
            end else begin
                mod_i = mod_i + 1;
            end
        end
    end
end


    // task verification_I_Q(input logic b0, input logic data_in, output logic [15:0] I, output logic [15:0] Q); // task for self checking
    //     begin
          
    //  case ({b0,data_in})

    //                     2'b00: begin I <= ZeroPointSeven; Q <= ZeroPointSeven; end // 00 -> (+0.707, +0.707)
    //                     2'b01: begin I <= ZeroPointSeven; Q <= NegativeZeroPointSeven; end // 01 -> (+0.707, -0.707)
    //                     2'b10: begin I <= NegativeZeroPointSeven; Q <= ZeroPointSeven; end // 10 -> (-0.707, +0.707)
    //                     2'b11: begin I <= NegativeZeroPointSeven; Q <= NegativeZeroPointSeven; end // 11 -> (-0.707, -0.707)
    //                    // default: begin I <= 16'b0; Q <= 16'b0; end
                            
    //                         endcase 
    //     end
    //  endtask

    // task automatic enter_96_inputs(
    //     input int start,
    //     input int STOP,
    //     input logic [95:0] data_in,
    //     output logic test_data
    // );
    //     for (int i = STOP; i >= start; i--) begin
    //         test_data = data_in[i];
    //         // $display("Time=%0t | Sending bit %0d: %b", $time, i, test_data);
    //         #(CLK_50_PERIOD);
    //     end
    // endtask

    // task compare_output(input logic [95:0] actual_output, input logic [95:0] expected_output);
    //     integer bit_idx;
    //     integer error_count;
    //     begin
    //         error_count = 0;
    //         for (bit_idx = 95; bit_idx >= 0; bit_idx = bit_idx - 1) begin
    //             if (actual_output[bit_idx] !== expected_output[bit_idx]) begin
    //                 $display("Mismatch at bit %0d: Expected %b, Got %b", bit_idx, expected_output[bit_idx], actual_output[bit_idx]);
    //                 error_count = error_count + 1;
    //             end else begin
    //                 $display(" Bit %0d: Expected %b, Got %b", bit_idx, expected_output[bit_idx], actual_output[bit_idx]);
    //             end
    //         end
    //         if (error_count == 0) begin
    //             $display("Test Passed: Output matches expected output vector.");
    //         end else begin
    //             $display("Test Failed: %0d mismatches found.", error_count);
    //         end
    //     end
    // endtask

    // task verification_I_Q(input logic b0, input logic data_in, output logic [15:0] I, output logic [15:0] Q); // task for self checking
    //     begin
          
    //  case ({b0,data_in})

    //                     2'b00: begin I <= ZeroPointSeven; Q <= ZeroPointSeven; end // 00 -> (+0.707, +0.707)
    //                     2'b01: begin I <= ZeroPointSeven; Q <= NegativeZeroPointSeven; end // 01 -> (+0.707, -0.707)
    //                     2'b10: begin I <= NegativeZeroPointSeven; Q <= ZeroPointSeven; end // 10 -> (-0.707, +0.707)
    //                     2'b11: begin I <= NegativeZeroPointSeven; Q <= NegativeZeroPointSeven; end // 11 -> (-0.707, -0.707)
    //                    // default: begin I <= 16'b0; Q <= 16'b0; end
                            
    //                         endcase 
    //     end
    //  endtask  

endmodule