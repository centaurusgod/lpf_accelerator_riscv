`timescale 1ns/1ps
module d_ff_tb;
    reg d;
    reg clk;
    reg reset;
    wire q;
    
    d_ff uut(
        .d(d),
        .clk(clk),
        .q(q),
        .rst(reset)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("d_ff.vcd");
        $dumpvars(0, d_ff_tb);

        // initially clk=0;
        clk =0;
        reset=0;
        d=0;

        #10 d = 1; // Change D after first posedge
        #10 d = 0;
        #10 d = 1;

        #5 reset=1;
        
        #10 $finish;

    end

    initial $monitor("time=%g, rst=%b, clk=%b, d=%b, q=%b", $time, reset, clk, d, q);

endmodule