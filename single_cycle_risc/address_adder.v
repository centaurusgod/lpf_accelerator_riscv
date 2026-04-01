module address_adder (
    input [31:0] a,
    input [31:0] b,
    output [31:0] out
);
    // pc = pc + 4
    // each instruction size 32 bits
    assign out = a + b;

endmodule
