module PPBuffer (
    input  logic       clk,
    input  logic       resetN, 
    input  logic [8:0] wraddress,
    input  logic       wrdata,
    // input  logic q_A,
    input  logic [8:0] rdaddress,
    // input  logic wrdata_B,
    input  logic       valid_prev,

    output logic       q
);

logic q_A;
logic q_B;
logic rden_A;
logic rden_B;
logic wren_A;
logic wren_B;

PPBufferControl BufferControl (
    .clk(clk),
    .resetN(resetN),
    .valid_prev(valid_prev),
    .q_A(q_A),
    .q_B(q_B),
    .rden_A(rden_A),
    .rden_B(rden_B),
    .wren_A(wren_A),
    .wren_B(wren_B),
    .q(q)
);

// DPR Banks
SDPR BankA (
    .clock(clk),
    .data(wrdata),
    .wraddress(wraddress),
    .wren(wren_A),
    .rdaddress(rdaddress),
    .rden(rden_A),
    .q(q_A)
);

SDPR BankB (
    .clock(clk),
    .data(wrdata),
    .wraddress(wraddress),
    .wren(wren_B),
    .rdaddress(rdaddress),
    .rden(rden_B),
    .q(q_B)
);
endmodule