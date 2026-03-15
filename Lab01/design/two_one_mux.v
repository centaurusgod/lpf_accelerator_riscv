// 2 bit 2:1 MUX
module two_one_mux (
    input [1:0] A,
    input [1:0] B,
    input sel,
    output wire [1:0] q
);

    //assign q = (sel) ? B : A;

    always @(sel) begin
        case (sel)
            1'b0: q = A;
            1'b1: q = B;
            default: q = 2'bxx;
        endcase
    end
    
endmodule


// 1 bit 2:1 mux
// module two_one_mux (
//     input [1:0] d, sel,
//     output reg q
// );
//     always @(sel) begin
//         case (sel)
//             1'b0 : q = d[0];
//             1'b1 : q = d[1];
//             default: q =  1'bx;
//         endcase
//     end
    
// endmodule