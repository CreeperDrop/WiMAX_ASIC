module prbs_top(
    input  logic        clk,
    input  logic        resetN,
    input  logic        data_in,    // From TB
    input  logic [1:15] seed,
    input  logic        load,
    input  logic        en,
    input  logic        valid_in,   // From TB
    input  logic        ready_fec,  // From FEC
    output logic        data_out,
    output logic        valid_out,
    output logic        ready_randomizer    // To TB
);

logic en_ctrl;
logic load_ctrl;


prbsControl prbsControl_inst (
    .clk(clk),
    .resetN(resetN),
    .ready_tb(ready_fec),
    .valid_in(valid_in),
    .load(load),
    .en(en),
    .valid_out(valid_out),
    .ready_randomizer(ready_randomizer)
);

prbs prbs_inst (
    .data_in(data_in),
    .clk(clk),
    .resetN(resetN),
    .load(load_ctrl),
    .en(en_ctrl),
    .seed(seed),
    .data_out(data_out)
);

endmodule