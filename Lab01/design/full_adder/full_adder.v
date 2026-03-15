module full_adder(
    input a, b, c,
    output s, carry
);
    wire s1;
    wire c1;
    wire c2;

    half_adder hf1(
        .a(a),
        .b(b),
        .s(s1),
        .c(c1)
    );

    half_adder hf2(
        .a(s1),
        .b(c),
        .s(s),
        .c(c2)
    );

    assign carry = c1 | c2;


endmodule