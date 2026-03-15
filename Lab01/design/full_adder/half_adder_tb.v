`timescale 1ns/1ps
module half_adder_tb;
    reg a;
    reg b;

    wire s;
    wire c;

    half_adder uut(
        .a(a),
        .b(b),
        .c(c),
        .s(s)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, half_adder_tb);

        a = 1'b0;
        b=1'b0;

        #5;
        // a =0, b=1;
        a = 1'b0;
        b=1'b1;

        #5;
        a=1'b1; b=1'b0;

        #5;
        a=1'b1; b=1'b1;

        #5;

        $finish;

    end

    initial $monitor("time = %g, a=%b, b=%b, s=%b, c=%b",$time, a,b,s,c);


    
endmodule