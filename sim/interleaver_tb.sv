module interleaver_tb;
    
    bit clk;
    bit resetN;

    bit [$clog2(192)-1:0] k;

    bit [191:0] data_in = 192'h2833E48D392026D5B6DC5E4AF47ADD29494B6C89151348CA;
    bit         data_serial;
    bit [191:0] data_out;

    interleaver dut(
        .clk(clk),
        .resetN(resetN),
        .data_in(data_in),

        .data_out(data_out)
    );

    initial begin
        resetN = 0;
        #20;
        resetN = 1;
        clk = 1;
        forever #10 clk = ~clk;
    end

    always @(posedge clk or negedge resetN) begin
        if(resetN == 1'b0) begin
            k <= 0;
        end else begin
            k <= k + 1;
        end
    end

    // assign data_serial = data_in[k];

    initial begin
        
        while(k != 191) begin
            @(posedge clk);
        end

        $display("Data out = %h", data_out);
        $stop();
    end

endmodule

