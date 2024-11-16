module out_interlace_tb();
    bit x;
    bit y;
    bit z;

    bit clk_100;

    parameter PERIOD_50M = 20ns;
    parameter PERIOD_100M = 10ns;

    out_interlace dut (
        .x(x),
        .y(y),
        .clk_100(clk_100),
        .z(z)
    );

    initial begin
        clk_100 = 0;
        forever #(PERIOD_100M/2) clk_100 = ~clk_100;
        
    end

    initial begin
        $monitor("Time = %0t, clk_100 = %b, x = %b, y = %b, z = %b", $time, clk_100, x, y, z);
        
        x = 0;
        y = 0;
        #(PERIOD_50M)
        x = 1;
        y = 0;
        #(PERIOD_50M)
        x = 1;
        y = 1;
        #(PERIOD_50M)
        x = 0;
        y = 1;
        #(PERIOD_50M)
        x = 1;
        y = 1;
        #(PERIOD_50M)
        x = 0;
        y = 0;

        #(PERIOD_50M)
        $stop();

    end


endmodule