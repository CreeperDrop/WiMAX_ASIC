module interleaver #(
    parameter Ncbps = 192,   // Coded Bits Per Second
    parameter Ncpc  = 2,     // Coded bits per carrier = 2 (QPSK)
    parameter s     = Ncpc/2,
    parameter d     = 16
)
(
    input  logic                     clk,
    input  logic                     resetN,
    input  logic                     ready_mod,            // Ready from mod
    input  logic                     valid_fec,            // Valid from FEC
    input  logic                     data_in,              // Data from FEC

    output logic                     data_out,
    output logic [$clog2(Ncbps)-1:0] data_out_index,
    output logic                     ready_interleaver,   // Ready out from interleaver
    output logic                     valid_interleaver    // Valid out from interleaver
);

logic [$clog2(Ncbps)-1:0] k;
logic [$clog2(Ncbps)-1:0] m;
logic [$clog2(Ncbps)-1:0] j;
logic                     interleave_en;
// logic [$clog2(Ncbps)-1:0] k, m, j;

always_ff @(posedge clk or negedge resetN) begin
    if(resetN == 1'b0) begin
        k <= '0;

    end else if(interleave_en == 1'b1) begin

        if(k == 191) k <= 0;
        else         k <= k + 1;

    end
end

always_comb begin
    m = ((Ncbps/d) * (k % d)) + k/d;
    j = (s * (m/s)) + ((m + Ncbps - ((d * m)/Ncbps)) % s);
    data_out_index = j;
    data_out = data_in;
end

always_comb begin
        if(valid_fec == 1'b1) begin
            interleave_en = 1'b1;
            valid_interleaver = 1'b1;
        end else begin
            interleave_en = 1'b0;
            valid_interleaver = 1'b0;
        end
        ready_interleaver = 1'b1;
        
end


endmodule