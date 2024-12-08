module prbs_verify_tb();

timeunit 1ns;
timeprecision 1ps;


logic clk;
logic reset_N;
logic load;
logic en;
logic pass;

prbs_verify prbs_verify_inst(.clk(clk), .reset_N(reset_N), .load(load), .en(en), .pass(pass));

initial begin
    clk = 1'b0;
    forever #10 clk = ~clk;
end

initial begin
    reset_N = 1'b0;
    load = 1'b0;
    en = 1'b0;
    #20
    reset_N = 1'b1;
    #20
    load = 1'b1;
    #20
    load = 1'b0;
    #20
    en = 1'b1;
    #10000
    $stop;
end

endmodule