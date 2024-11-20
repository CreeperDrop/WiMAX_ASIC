module prbs_tb();
    
    bit data_in;
    bit clk;
    bit reset;
    bit load;
    bit en;
    bit data_out;
    bit ready_fec;
    bit valid_in;
    bit valid_out;
    bit ready_prbs;

    bit [1:96] output_sequence;
    bit [1:96] input_sequence = 96'hACBCD2114DAE1577C6DBF4C9;
    bit [1:15] seed = 15'b011011100010101;
    bit [1:96] expected_out = 96'h558AC4A53A1724E163AC2BF9;
    integer i = 1;
    // bit [95:0] expected_out = 96'h9FB2CA361E4271A35A4CA855;

    prbs dut(
            .data_in(data_in),
            .clk(clk),
            .reset(reset),
            .load(load),
            .en(en),
            .seed(seed),
            .ready_fec(ready_fec),
            .valid_in(valid_in),
            .valid_out(valid_out),
            .ready_prbs(ready_prbs),
            .data_out(data_out)
            );
            
    initial forever #10 clk = ~clk;

    initial begin
        clk = 0;
        reset = 0;
        reset = 1;
        #20;
        reset = 0; // Reset sequence
        ready_fec = 1;
        valid_in = 1;
        en = 0;
        load = 0;
        #20; 
         // time for load to happen
        load = 1;
        en = 1;
        
        repeat (96) begin @(posedge clk) begin
                data_in = input_sequence[i];
                #1;
                output_sequence[i] = data_out;
                i++;
                #1;
                load = 0;
            end
        end 

        if(output_sequence == expected_out) begin
            $display("Output: %h\t\tExpected: %h\tTEST PASSED", output_sequence, expected_out);
        end else begin
             $display("Output: %h\t\tExpected: %h\tTEST FAILED", output_sequence, expected_out);
        end

        $stop();

    end

 

        // output check
        // expected_out[0:95] = 96'h558AC4A53A1724E163AC2BF9;


endmodule