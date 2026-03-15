// `include "d_ff.v"
module t_ff (
    input clk, rst,
    output q
);

    wire d;

    d_ff uut(
        .clk(clk),
        .rst(rst),
        .d(d),
        .q(q)
    );

    assign d = ~q;
    
endmodule