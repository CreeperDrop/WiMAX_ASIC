module interleaver_top #(
    parameter Ncbps = 192,   // Coded Bits Per Second
    parameter Ncpc  = 2,     // Coded bits per carrier = 2 (QPSK)
    parameter s     = Ncpc/2,
    parameter d     = 16
) (
    input  logic clk,
    input  logic resetN,
    input  logic data_in,
    input  logic ready_in,
    input  logic valid_in,
    
    output logic data_out,
    output logic valid_out,
    output logic ready_out
);

logic [8:0] data_out_index;
logic       ready_interleaver;
logic       valid_interleaver;
logic [8:0] rdaddress;

interleaver Interleaver_inst (
    .clk(clk),
    .resetN(resetN),
    .ready_buffer(ready_out),
    .valid_fec(valid_in),
    .data_in(data_in),
    .data_out(data_interleaved),
    .data_out_index(data_out_index),
    .ready_interleaver(ready_interleaver),
    .valid_interleaver(valid_interleaver)
);

PPBuffer PingPongBuffer_inst (
    .clk(clk),
    .resetN(resetN),
    .wraddress(data_out_index),
    .wrdata(data_interleaved),
    .rdaddress(rdaddress),
    .valid_in(valid_interleaver),
    .q(data_out),
    .valid_out(valid_out),
    .ready_out(ready_out)
);

ReadControl ReadControl_inst (
    .clk(clk),
    .resetN(resetN),
    .valid_out(valid_out),
    .ready_out(ready_out),
    .rdaddress(rdaddress)
);

// always_ff @(posedge clk or negedge resetN) begin
//     if(resetN == 1'b0) begin
//         rdaddress <= '0;
//     end else if(ready_out == 1'b1) begin
//         if(rdaddress == 191) rdaddress <= '0;
//         else                 rdaddress <= rdaddress + 1;
//     end
// end

endmodule