module interleaver_top_tb();
    timeunit 1ns;
    timeprecision 1ps;
    
    // Testbench signals
    logic clk;
    logic resetN;
    logic ready_in;
    logic valid_fec;
    logic data_in;
    logic data_out;
    logic ready_interleaver;
    logic valid_interleaver;
    
    parameter Ncbps = 192;   // Coded Bits Per Symbol
    parameter Ncpc  = 2;     // Coded Bits Per Carrier = 2 (QPSK)
    parameter s     = Ncpc/2;
    parameter d     = 16;
    parameter CLK_PERIOD = 10ns;

    logic [0:191] predicted_out    = 192'h4B047DFA42F2A5D5F61C021A5851E9A309A24FD58086BD1E;  // Golden data
    logic [0:191] data_in_sequence = 192'h2833E48D392026D5B6DC5E4AF47ADD29494B6C89151348CA; // Golden data
    logic [0:191] data_out_sequence;

    // Instantiate the interleaver module
    interleaver_top #(
        .Ncbps(Ncbps),
        .Ncpc(Ncpc),
        .s(s),
        .d(d)
    ) dut (
        .clk(clk),
        .resetN(resetN),
        .data_in(data_in),
        .ready_in(ready_in),
        .valid_in(valid_fec),
        .data_out(data_out),
        .valid_out(valid_interleaver),
        .ready_out(ready_interleaver)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk; // 100 MHz clock (10 ns period)
    end

    integer i;
    initial begin
        // Initialize signals
        resetN = 0;
        valid_fec = 0;
        ready_in = 0;
        // data_in = 0;

        // Apply reset
        #(CLK_PERIOD);
        resetN = 1;
        
        // Wait for the interleaver to be ready
        while (!ready_interleaver) begin
            #(CLK_PERIOD);
        end
        
        // Start sending data
        valid_fec = 1;
        ready_in = 1;
        for (int pass = 0; pass < 5; pass++) begin
            for (i = 0; i < 192; i++) begin
                // Feed data bit by bit
                data_in = data_in_sequence[i];
                #(CLK_PERIOD / 2);

                // Display data
                $display("Data in: %b | @Index: %d | Data out: %b | @Index: %d | rdaddress: %0d", 
                          data_in, i, data_out, dut.data_out_index, dut.rdaddress);
                #(CLK_PERIOD / 2);
                // Capture output data into the sequence buffer
                if (valid_interleaver && ready_in) begin
                    data_out_sequence[dut.data_out_index] = data_out;
                end
            end
            $display("Data out sequence %d: %h", pass, data_out_sequence);

            // Check if the output sequence matches the expected output
            if (data_out_sequence === predicted_out) begin
                $display("Test passed for pass %0d", pass);
            end else begin
                $display("Test failed for pass %0d", pass);
            end
        end
        
        // $display("Final Data out sequence: %h", data_out_sequence);
        $stop;
    end

    // Timeout to avoid infinite simulation
    initial begin
        #100000;
        $display("ERROR: Simulation Timeout");
        $stop;
    end
endmodule
