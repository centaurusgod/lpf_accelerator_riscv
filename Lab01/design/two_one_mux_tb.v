`timescale 1ns/1ps
module two_one_mux_tb;
    reg [1:0] A;
    reg [1:0] B;
    reg sel;
    wire [1:0] q ;

    two_one_mux uut(
        .A(A),
        .B(B),
        .sel(sel),
        .q(q)
    );

    always #5 sel = ~ sel;

    initial begin
        $dumpfile("two_one_mux_tb.vcd");
        $dumpvars(0, two_one_mux_tb); 

        // initialize sel, A and B
        sel=0;
        A =  2'b11;
        B = 2'b00;
        #10;

        A = 2'b10;
        B = 2'b11;

        #20;
        A = 2'b00;
        B = 2'b10;

        #120;

        $finish;

    end

    initial $monitor("time=%g, sel=%b, A=%b, B=%b, q=%b", $time, sel, A, B, q);

endmodule
