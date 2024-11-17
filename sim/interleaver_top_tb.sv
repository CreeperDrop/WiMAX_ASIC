module interleaver_top_tb();
timeunit 1ns;
timeprecision 1ps;
// Testbench signals
logic clk;
logic resetN;
logic ready_mod;
logic valid_fec;
logic data_in;

logic data_out;
// logic [8:0] data_out_index;
logic ready_interleaver;
logic valid_interleaver;

parameter Ncbps = 192;   // Coded Bits Per Second
parameter Ncpc  = 2;     // Coded bits per carrier = 2 (QPSK)
parameter s     = Ncpc/2;
parameter d     = 16;

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
    .ready_in(ready_mod),
    .valid_in(valid_fec),
    .data_out(data_out),
    .valid_out(valid_interleaver),
    .ready_out(ready_interleaver)
);

// Clock Generation
always #10 clk = ~clk; // 100 MHz clock (10 ns period)

integer i = 0;

// Initial block to drive the test
initial begin
    // Initialize signals
    clk = 0;
    resetN = 0;
    valid_fec = 0;
    // data_in = 0;
    ready_mod = 0;
    
    #10ns;
    resetN = 1;
    // Test sequence
    // @(posedge clk);
    valid_fec = 1;

    while(!ready_interleaver) begin
        @(posedge clk);
        // data_in = data_in_sequence[0];
        // #1;
    end
    ready_mod = 1;

    // while(!valid_interleaver) begin
    //     #10;
    // end
    // #10ns;

        for(i = 0; i < 192; i = i + 1) begin
                data_in = data_in_sequence[i];
                @(posedge clk);
                // $display("Time: %0t @ Data in: %h", $time, data_in);
                // $display("Data in: %h", data_in);
                // #5;
                // data_out_sequence[dut.data_out_index] = data_out;
                // $display("Data out: %h Predicted Data out: ", data_out, predicted_out[dut.data_out_index]);
                // if(data_out != predicted_out[dut.data_out_index]) begin
                //     $display("Test failed at index %d", i);
                //     $stop;
                // end
                // #5;
            
        end
    repeat(10) begin
        for(i = 0; i < 192; i = i + 1) begin
                data_in = data_in_sequence[i];
                // $display("Data in: %h", data_in);
                #20;
                data_out_sequence[dut.data_out_index] = data_out;
                
                // #10;
            
        end
        $display("Data out: %h", data_out_sequence);
    end
    $stop;
end

// initial begin
//     #10000ns;
//     $display("Simulation time out");
//     $stop;
// end
endmodule