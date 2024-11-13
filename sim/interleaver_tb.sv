module interleaver_tb;
timeunit 1ns;
timeprecision 1ps;

parameter CLK_PERIOD = 20ns;

bit clk;
bit resetN;

bit [$clog2(192)-1:0] k;

bit [191:0] data_in = 192'h2833E48D392026D5B6DC5E4AF47ADD29494B6C89151348CA;
bit [191:0] data_out;

bit data_in_serial;
bit ready_mod = 1'b1;
bit valid_fec;
bit ready_interleaver;
bit valid_interleaver;

interleaver dut(
    .clk(clk),
    .resetN(resetN),
    .ready_mod(ready_mod),
    .valid_fec(valid_fec),
    .data_in(data_in_serial),
    .data_out(data_out),
    .ready_interleaver(ready_interleaver),
    .valid_interleaver(valid_interleaver)
);

// Clock Generation
initial begin
    clk = 1;
    forever #(CLK_PERIOD/2) clk = ~clk; // 50MHz clock (20ns period)
end

// Reset Generation
initial begin
    resetN = 0;
    #(CLK_PERIOD); // Wait for a few cycles
    resetN = 1;
end

// Data Serialization and k Counter
always @(posedge clk or negedge resetN) begin
    if (resetN == 1'b0) begin
        k <= 0;
        valid_fec <= 1'b0;
    end else begin
        if (k < 192) begin
            data_in_serial <= data_in[k]; // Serialize data_in
            k <= k + 1;
            valid_fec <= 1'b1;
        end else begin
            valid_fec <= 1'b0; // Stop sending data after 192 bits
        end
    end
end

// Simulation control
initial begin
    // Add a delay to allow simulation to complete data transmission
    #5000; 
    $display("Data out = %h", data_out);
    $stop();
end

endmodule
