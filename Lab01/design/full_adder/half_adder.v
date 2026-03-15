module half_adder (
    output s, 
    output c, 
    input a, 
    input b
);
    assign s = a^b;
    assign c = a&b;
endmodule