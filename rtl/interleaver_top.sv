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
logic       read_en;
logic       buffer_filled;

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

// always_ff @(posedge clk or negedge resetN) begin
//     if(resetN == 1'b0) begin
//         rdaddress <= '0;
//     end else if(read_en) begin
//         if(rdaddress == 191) rdaddress <= '0;
//         else                 rdaddress <= rdaddress + 1;
//     end
// end

// assign read_en = valid_out && ready_out;

// Buffer filled flag logic
always_ff @(posedge clk or negedge resetN) begin
    if (resetN == 1'b0) begin
        buffer_filled <= 1'b0;
    end else if (valid_interleaver && (data_out_index == (Ncbps - 1))) begin
        buffer_filled <= 1'b1; // Set flag when buffer is fully written
    end
end

// Read address logic
always_ff @(posedge clk or negedge resetN) begin
    if (resetN == 1'b0) begin
        rdaddress <= '0;
    end else if (read_en && buffer_filled) begin
        if (rdaddress == (Ncbps - 1)) begin
            rdaddress <= '0;
        end else begin
            rdaddress <= rdaddress + 1;
        end
    end
end

// Read enable signal
assign read_en = valid_out && ready_out && buffer_filled;


endmodule