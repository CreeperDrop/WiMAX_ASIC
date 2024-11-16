module out_interlace(
    input logic x,
    input logic y,
    input logic clk_100,
    output logic z
);

assign z = (clk_100 == 1'b1) ? y : x;

endmodule