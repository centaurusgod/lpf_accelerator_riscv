`timescale 1ns/1ps
module t_ff_tb;
    reg clk;
    reg rst;
    wire q;

    t_ff uut(
        .clk(clk),
        .rst(rst),
        .q(q)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("t_ff.vcd");
        $dumpvars(0, t_ff_tb);

        // reset initially to set q =0;
        rst=1;
        clk=0;
        #12;

        rst =0;

        #20;
        $finish;


    end

    initial $monitor("time=%g, rst=%b, clk=%b,  q=%b", $time, rst, clk, q);
    
endmodule