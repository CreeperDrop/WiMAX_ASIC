module prbs_tb();

    timeunit 1ns;
    timeprecision 1ps;
    
    logic        data_in;
    logic        clk;
    logic        reset;
    logic        load;
    logic        en;
    logic [1:15] seed = 15'b011011100010101;
    logic        ready_fec; // Ready from FEC
    logic        valid_in;  // Valid from testbench
    logic        data_out;
    logic        valid_out;
    logic        ready_randomizer;    // Ready out from randomizer
    
    parameter CLK_PERIOD = 10;

    logic [0:95] data_in_sequence = 96'hACBCD2114DAE1577C6DBF4C9;
    logic [0:95] data_out_expected = 96'h558AC4A53A1724E163AC2BF9;
    logic [0:95] data_out_sequence;

    // logic [1:15] seed = 15'b011011100010101;

    // Clock gen
    initial begin
        clk = 1;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    // Instantiate the Device Under Test (DUT)
    // prbs dut (
    //     .data_in(data_in),
    //     .clk(clk),
    //     .reset(reset),
    //     .load(load),
    //     .en(en),
    //     .seed(seed),
    //     .ready_fec(ready_fec),
    //     .valid_in(valid_in),
    //     .data_out(data_out),
    //     .valid_out(valid_out),
    //     .ready_randomizer(ready_randomizer)
    // );

    prbs_top dut (
        .clk(clk),
        .resetN(reset),
        .data_in(data_in),
        .seed(seed),
        .load(load),
        .en(en),
        .valid_in(valid_in),
        .ready_fec(ready_fec),
        .data_out(data_out),
        .valid_out(valid_out),
        .ready_randomizer(ready_randomizer)
    );
    // Test sequence
    initial begin
        // Reset sequence
        reset = 0;
        #(CLK_PERIOD);
        reset = 1;
        #(CLK_PERIOD);

        ready_fec = 1;
        load = 0;
        en = 0;
        valid_in = 0;
        
        #(2*CLK_PERIOD);

        load = 1;
        en = 0;
        valid_in = 0;

        // while(!ready_randomizer) begin
            #(2*CLK_PERIOD);
        // end

        // load = 0;
        en = 1;
        valid_in = 1;
        ready_fec = 1;

        // data_in = data_in_sequence[0];
        // data_out_sequence[0] = data_out;

        for(int pass = 0; pass < 5; pass++) begin
            for(int i = 0; i < 96; i++) begin
                data_in = data_in_sequence[i];
                #(CLK_PERIOD/2);
                data_out_sequence[i] = data_out;
                #(CLK_PERIOD/2);
            end
            if(data_out_sequence === data_out_expected) begin
                $display("Test %0d passed", pass);
            end else begin
                $display("Test %0d failed", pass);
            end
        end

        $stop();
    end
endmodule