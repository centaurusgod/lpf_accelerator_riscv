`timescale 1ns/1ps
module full_adder_tb;
    reg a;
    reg b;
    reg c;

    wire s;
    wire carry;

    full_adder uut(
        .a(a),
        .b(b),
        .c(c),
        .s(s),
        .carry(carry)
    );

    initial begin
        $dumpfile("full_adder.vcd");
        $dumpvars(0, full_adder_tb);

        {a,b,c}=3'b000;

        #2 {a,b,c}=3'b001;
        #2 {a,b,c}=3'b010;
        #2 {a,b,c}=3'b011;
        #2 {a,b,c}=3'b100;
        #2 {a,b,c}=3'b101;
        #2 {a,b,c}=3'b110;
        #2 {a,b,c}=3'b111;

        #20 $finish;
        
    end

    initial $monitor("time = %g, a=%b, b=%b, c=%b, sum=%b, carry=%b",$time, a,b,c,s,carry);

    
endmodule