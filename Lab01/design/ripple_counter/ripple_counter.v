// `include "t_ff.v"

module ripple_counter (
    input clk, rst,
    output [3:0] q
);
    t_ff t0(
        .clk(clk),
        .rst(rst),
        .q(q[0])
    );
    t_ff t1(
        .clk(q[0]),
        .rst(rst),
        .q(q[1])
    );
    t_ff t2(
        .clk(q[1]),
        .rst(rst),
        .q(q[2])
    );
    t_ff t3(
        .clk(q[2]),
        .rst(rst),
        .q(q[3])
    );
    
endmodule