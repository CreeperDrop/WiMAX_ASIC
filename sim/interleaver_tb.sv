`timescale 1ns / 1ps

module interleaver_tb;

// Parameters
parameter Ncbps = 192;   // Coded Bits Per Second
parameter Ncpc  = 2;     // Coded bits per carrier = 2 (QPSK)
parameter s     = Ncpc/2;
parameter d     = 16;

// Testbench Signals
logic                     clk;
logic                     resetN;
logic                     ready_mod;
logic                     valid_fec;
logic                     data_in;

logic                     data_out;
logic [$clog2(Ncbps)-1:0] data_out_index;
logic                     ready_interleaver;
logic                     valid_interleaver;

logic [0:191] predicted_out = 192'h4B047DFA42F2A5D5F61C021A5851E9A309A24FD58086BD1E;  // Golden data
logic [0:191] data_in_sequence = 192'h2833E48D392026D5B6DC5E4AF47ADD29494B6C89151348CA; // Golden data
// Instantiate the interleaver module
interleaver #(
    .Ncbps(Ncbps),
    .Ncpc(Ncpc),
    .s(s),
    .d(d)
) dut (
    .clk(clk),
    .resetN(resetN),
    .ready_mod(ready_mod),
    .valid_fec(valid_fec),
    .data_in(data_in),
    .data_out(data_out),
    .data_out_index(data_out_index),
    .ready_interleaver(ready_interleaver),
    .valid_interleaver(valid_interleaver)
);

// Clock Generation
always #5 clk = ~clk; // 100 MHz clock (10 ns period)

integer i = 0;

// Initial block to drive the test
initial begin
    // Initialize signals
    clk = 0;
    resetN = 0;
    ready_mod = 1;
    valid_fec = 0;
    data_in = 0;
    
    #10;
    resetN = 1;
    display_header();
    // Test sequence
    valid_fec = 1;
    repeat(10) begin
        $display("Starting test...");
        i = 0;
        while(i < 192) begin
            data_in = data_in_sequence[i];
            #5;
            $display("data_out[%0d] = %h, predicted_out[%0d] = %h", data_out_index, data_out, data_out_index, predicted_out[data_out_index]);
            // display_cell();
            if(data_out != predicted_out[data_out_index]) begin
                $display("Error: data_out[%0d] = %h, predicted_out[%0d] = %h", i, data_out, i, predicted_out[data_out_index]);
                // $display("Test failed.");
                // $stop;
            end
            i++;
            #5;
            
        end
        display_footer();
    end
    $display("Test completed.");

    $stop;
end


task display_header();
    $display("===================================================");
    $display("=            Interleaver Testbench               =");
    $display("===================================================");
    // $display("Data in   Data_in_index   Data out   Data_out_index   Expected_Data_out  Expected_Data_out_index");

endtask

task display_footer();
    $display("===================================================");
    $display("=            End of Interleaver Testbench         =");
    $display("===================================================");
endtask

task display_cell();
    $display("%b       %3d   %b   %3d   %b   %3d", data_in, data_out_index, data_out, data_out_index, predicted_out[data_out_index], data_out_index);
endtask
endmodule