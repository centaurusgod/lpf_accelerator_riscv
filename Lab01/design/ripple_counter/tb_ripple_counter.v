`include "ripple_counter.v"
`timescale 1ns/1ps
module tb_ripple_counter;
    reg clk;
    reg rst;
    wire [3:0] q;

    ripple_counter r1
    (
        .rst(rst),
        .q(q),
        .clk(clk)
    );

    always #5 clk = ~clk;



    initial begin
        $dumpfile("tb_ripple_counter.vcd");
        $dumpvars(0, tb_ripple_counter);
    end

    initial begin
        // run with no reset
        clk = 0;
        rst = 1;
        #10;
        rst=0; #5;
        


        #200;
        $finish;


    end
    
    always @(negedge clk) begin
        $display("%d \t %h \t %b", q, q, q);
    end

endmodule