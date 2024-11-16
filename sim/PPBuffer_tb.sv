module PPBuffer_tb();
    timeunit 1ns;
    timeprecision 1ps;
    // Testbench signals
    logic clk;
    logic resetN;
    logic [8:0] wraddress;
    logic wrdata;
    logic [8:0] rdaddress;
    logic valid_prev;
    logic q;

    parameter CLK_PERIOD = 10;
    parameter BUFFER_SIZE = 192; // Maximum buffer size

    logic [BUFFER_SIZE-1:0] data_in = 192'h2833E48D392026D5B6DC5E4AF47ADD29494B6C89151348CA;
    logic [BUFFER_SIZE-1:0] data_out;
    // Instantiate the Device Under Test (DUT)
    PPBuffer dut (
        .clk(clk),
        .resetN(resetN),
        .wraddress(wraddress),
        .wrdata(wrdata),
        .rdaddress(rdaddress),
        .valid_prev(valid_prev),
        .q(q)
    );

    // Clock generation
    initial begin
        clk = 1;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    // // Reset sequence
    // initial begin
    //     resetN = 0;
    //     #CLK_PERIOD;
    //     resetN = 1;
    // end

    // Test sequence
    initial begin
        // Reset sequence
        resetN = 0;
        #(CLK_PERIOD/2);
        resetN = 1;
        #(CLK_PERIOD/2);
        valid_prev = 1;
        // // Test Case 1: Fill Bank A
        // valid_prev = 1;
        // for(int i = 0; i < BUFFER_SIZE; i++) begin
        //     wraddress = i;
        //     wrdata = data_in[i];
        //     // wrdata = $urandom_range(0, 1);
        //     #CLK_PERIOD;
        //     data_out[i] = q;
        // end
        // $display("Test 1: Data out: 0x%h", data_out);
        // data_out = 'x;
        // // Test Case 2: Fill Bank B and consumer reads from Bank A
        // for(int i = 0; i < BUFFER_SIZE; i++) begin
        //     wraddress = i;
        //     wrdata = data_in[i];
        //     // wrdata = $urandom_range(0, 1);
        //     rdaddress = i;
        //     #CLK_PERIOD;
        //     data_out[i] = q;
        // end
        // $display("Test 2: Data out: 0x%h", data_out);
        // data_out = 'x;
        // // Test Case 3: Fill Bank A and consumer reads from Bank B
        // for(int i = 0; i < BUFFER_SIZE; i++) begin
        //     wraddress = i;
        //     wrdata = data_in[i];
        //     // wrdata = $urandom_range(0, 1);
        //     rdaddress = i;
        //     #CLK_PERIOD;
        //     data_out[i] = q;
        // end
        // $display("Test 3: Data out: 0x%h", data_out);
        // data_out = 'x;

        // // Test Case 3: Fill Bank A and consumer reads from Bank B
        // valid_prev = 1;
        // for(int i = 0; i < BUFFER_SIZE; i++) begin
        //     wraddress = i;
        //     wrdata = data_in[i];
        //     #CLK_PERIOD;
        // end

        // // valid_prev = 0;
        // for(int i = 0; i < BUFFER_SIZE; i++) begin
        //     rdaddress = i;
        //     #CLK_PERIOD;
        //     data_out[i] = q;
        // end
        // $display("Test 3: Data out: 0x%h", data_out);
        // data_out = 'x;

        // Test Case 4: Check if streaming is possible
        repeat(2) begin
            for(int i = 0; i < BUFFER_SIZE; i++) begin
                wraddress = i;
                wrdata = data_in[i];
                rdaddress = i;
                #(CLK_PERIOD);
                data_out[i] = q;

            end
            $display("Data out: %h at time: %0t", data_out, $time);
        end
        // $display("Test 4: Data out: 0x%h", data_out);
        $stop;
    end
    
    // Timeout to avoid infinite simulation
    initial begin
        #100000;
        $display("ERROR: Simulation Timeout");
        $stop;
    end
endmodule
