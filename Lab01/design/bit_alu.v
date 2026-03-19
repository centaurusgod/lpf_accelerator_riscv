// let's try to use structural code more for better understanding
module bit_alu (
    input  a,
    input  b,
    input a_invert,
    input b_invert,
    input [1:0] alu_op,
    input  c_in,
    output reg result,
    output reg c_out
);

    wire mux1out;
    wire mux2out;

    wire and_op;
    wire or_op;
    wire sum;
    wire carry_out;

    assign mux1out = a_invert ? ~a : a;
    assign mux2out = b_invert ? ~b : b;

    and(and_op, mux1out, mux2out);
    or(or_op, mux1out, mux2out);
    full_adder adder_inst (
        .a(mux1out),
        .b(mux2out),
        .c(c_in),
        .s(sum),
        .carry(carry_out)
    );

    always @(*) begin
        case (alu_op)
            // select and
            2'b00: begin
                result = and_op;
                c_out = 0;
            end
            // select or
            2'b01: begin
                result = or_op;
                c_out = 0;
            end
            // select sum
            2'b10: begin
                result = sum;
                c_out = carry_out;
            end
            default: begin
                result = 1'bx; c_out = 1'bx;
            end 
        endcase
    end
endmodule