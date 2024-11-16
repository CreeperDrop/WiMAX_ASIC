module SPI_FSM_tb;

    // Parameters
    parameter PARALLEL_WIDTH = 8;
    
    // Inputs
    logic clk;
    logic resetN;
    logic serial_ready;
    logic serial_in;
    
    // Outputs
    logic parallel_ready;
    logic [PARALLEL_WIDTH-1:0] parallel_out;
    
    // Instantiate the SPI_FSM
    SPI_FSM #(
        .PARALLEL_WIDTH(PARALLEL_WIDTH)
    ) uut (
        .clk(clk),
        .resetN(resetN),
        .serial_ready(serial_ready),
        .serial_in(serial_in),
        .parallel_ready(parallel_ready),
        .parallel_out(parallel_out)
    );
    
    // Clock generation
    always #5 clk = ~clk;  // 100MHz clock
    
    always @(posedge clk) begin
        if(parallel_ready) begin
            $display("Serial transfer complete, serial_ready deasserted");
            $display("State: %b, parallel_out: %h", uut.state, parallel_out);
            if(parallel_out == 8'h55) begin
                $display("TEST PASSED");
            end else begin
                $display("TEST FAILED: parallel_out = %h", parallel_out);
            end
            $stop;
        end
    end



    // Test procedure
    initial begin
        // Initialize signals
        clk = 0;
        resetN = 0;
        serial_ready = 0;
        serial_in = 0;
        
        // Apply reset
        $display("Applying reset...");
        #10 resetN = 1;  // Release reset
        // #10 resetN = 0;  // Apply reset again for simulation
        
        // Start serial transfer
        $display("Starting serial transfer...");
        #20 serial_ready = 1;  // Assert serial_ready
        
        // Sending 8-bit data: 01010101 (0x55)
        serial_in = 0; #10;
        serial_in = 1; #10;
        serial_in = 0; #10;
        serial_in = 1; #10;
        serial_in = 0; #10;
        serial_in = 1; #10;
        serial_in = 0; #10;
        serial_in = 1; #10;
        
        // Stop the serial transfer after 8 bits
        serial_ready = 0;
        $display("Serial transfer complete, serial_ready deasserted");
        
        // Wait a few more clock cycles to see the final output
        #20;
        
        // Check output
        $display("State: %b, parallel_out: %h", uut.state, parallel_out);
        if(parallel_out == 8'h55) begin
            $display("TEST PASSED");
        end else begin
            $display("TEST FAILED: parallel_out = %h", parallel_out);
        end
        
        $stop;
    end
endmodule
