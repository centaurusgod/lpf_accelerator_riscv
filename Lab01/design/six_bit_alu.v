module six_bit_alu (
    input [5:0] a,
    input [5:0] b,
    input a_invert,
    input b_invert,
    input [1:0] alu_op,
    output  final_carry_out,
    output reg [5:0] result,
);

    wire [5:0] c_out;

    bit_alu b0(
        .a(a[0]),
        .b(b[0]),
        .a_invert(a_invert),
        .b_invert(b_invert),
        .alu_op(alu_op),
        .c_in(b_invert),
        .c_out(c_out[0]),
        .result(result[0])
    );
    
    bit_alu b1(
        .a(a[1]),
        .b(b[1]),
        .a_invert(a_invert),
        .b_invert(b_invert),
        .alu_op(alu_op),
        .c_in(c_out[0]),
        .c_out(c_out[1]),
        .result(result[1])
    );

    bit_alu b2(
        .a(a[2]),
        .b(b[2]),
        .a_invert(a_invert),
        .b_invert(b_invert),
        .alu_op(alu_op),
        .c_in(c_out[1]),
        .c_out(c_out[2]),
        .result(result[2])
    );
    bit_alu b3(
        .a(a[3]),
        .b(b[3]),
        .a_invert(a_invert),
        .b_invert(b_invert),
        .alu_op(alu_op),
        .c_in(c_out[2]),
        .c_out(c_out[3]),
        .result(result[3])
    );

    bit_alu b4(
        .a(a[4]),
        .b(b[4]),
        .a_invert(a_invert),
        .b_invert(b_invert),
        .alu_op(alu_op),
        .c_in(c_out[3]),
        .c_out(c_out[4]),
        .result(result[4])
    );

    bit_alu b5(
        .a(a[5]),
        .b(b[5]),
        .a_invert(a_invert),
        .b_invert(b_invert),
        .alu_op(alu_op),
        .c_in(c_out[4]),
        .c_out(c_out[5]),
        .result(result[5])
    );

    assign final_carry_out = c_out[5];

    
endmodule