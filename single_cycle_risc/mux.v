module mux (
    input [31:0] a,
    input [31:0] b,
    input sel,
    output [31:0] data_out
);

    assign data_out = sel ? b : a;
    
endmodule