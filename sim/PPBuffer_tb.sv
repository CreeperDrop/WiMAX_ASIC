module PPBuffer_tb();
    timeunit 1ns;
    timeprecision 1ps;
    // Testbench signals
    logic clk;
    logic resetN;
    logic [8:0] wraddress;
    logic wrdata;
    logic [8:0] rdaddress;
    logic valid_in;
    logic q;
    logic valid_out;
    logic ready_out;

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
        .valid_in(valid_in),
        .valid_out(valid_out),
        .ready_out(ready_out),
        .q(q)
    );

    // Clock generation
    initial begin
        clk = 1;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    // Test sequence
    initial begin
        // Reset sequence
        resetN = 0;
        #(CLK_PERIOD);
        resetN = 1;

        valid_in = 1;
        wraddress = 0;
        wrdata = data_in[0];
        rdaddress = 0;
        // #(CLK_PERIOD/2);
        while(!ready_out) begin
            #CLK_PERIOD;
        end
        // Fill Bank A
        for(int i = 0; i < BUFFER_SIZE; i++) begin
            wraddress = i;
            wrdata = data_in[i];
            rdaddress = i;
            #(CLK_PERIOD);
            data_out[i] = q;
        end

        repeat(10) begin
            for(int i = 0; i < BUFFER_SIZE; i++) begin
                wraddress = i;
                wrdata = data_in[i];
                rdaddress = i;
                #(CLK_PERIOD);
                data_out[i] = q;

            end
            if(data_out === data_in) begin
                $display("Test passed");
            end else begin
                $display("Test failed");
            end
            $display("Data out: %h at time: %0t", data_out, $time);
        end
        $display("Streaming successful");
        $stop;
    end

    // Timeout to avoid infinite simulation
    // initial begin
    //     #100000;
    //     $display("ERROR: Simulation Timeout");
    //     $stop;
    // end
endmodule
