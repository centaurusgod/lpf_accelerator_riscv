module four_one_mux (
    input [3:0] d,
    input [1:0] sel,
    output reg q
);

    always @(sel) begin
        casex (sel)
            2'b00 : q = d[0];
            2'b01 : q = d[1];
            2'b10 : q = d[2];
            2'b11 : q = d[3];
            default: q = 2'bx;
        endcase
    end
    
endmodule