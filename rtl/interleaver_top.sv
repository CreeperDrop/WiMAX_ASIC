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
    output logic [7:0] data_out_index,
    output logic data_out,
    output logic valid_interleaver,
    output logic ready_out
);

logic       ready_interleaver;
logic [7:0] wraddress;
logic [7:0] rdaddress;
logic       buffer_out;
logic       buffer_valid;
logic       valid_out;

interleaver Interleaver_inst (
    .clk(clk),
    .resetN(resetN),
    .ready_buffer(ready_out),
    .valid_fec(valid_out),
    .data_in(buffer_out),
    .data_out(data_out),
    .data_out_index(data_out_index),
    .ready_interleaver(ready_interleaver),
    .valid_interleaver(valid_interleaver)
);

PPBuffer PingPongBuffer_inst (
    .clk(clk),
    .resetN(resetN),
    .wraddress(wraddress),
    .wrdata(data_in),
    .rdaddress(wraddress),
    .valid_in(valid_in),
    .q(buffer_out),
    .ready_in(ready_in),
    .valid_out(valid_out),
    .ready_out(ready_out)
);


always_ff @(posedge clk or negedge resetN) begin
    if(resetN == 1'b0) begin
        wraddress <= '0;
    end else if(ready_out == 1'b1) begin
        if(wraddress == 8'd191) wraddress <= '0;
        else                    wraddress <= wraddress + 1'b1;
    end
end


endmodule