module pc_adder (
    input [31:0] a,
    output [31:0] out
);
    // pc = pc + 4
    // each instruction size 32 bits
    assign out = a +32'h4;

endmodule
