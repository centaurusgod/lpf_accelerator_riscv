module alu_control (
    input [1:0] alu_op,
    input [3:0] funct,

    output reg [3:0] operation
);

    always @(*) begin
        case (alu_op)
            2'b00 : begin
                operation = 4'b0010;
            end 
            2'b01 : begin
                operation = 4'b0110;
            end
            2'b10 : begin
                case (funct)
                    // add operation
                    4'b0000 : operation = 4'b0010;
                    // subtract operation ; signal b_invert operation
                    4'b1000 : operation = 4'b0110;
                    // and operation
                    4'b0111 : operation =  4'b0000;
                    // or operation
                    4'b0110 : operation =  4'b0001;

                    // shift left logical 4'b0001 : operation = 4'bx;
                    // shift right logical 4'b0101: 
                    // shift right arithmetic 4'b1101
                    default: operation =  4'b0000;
                endcase
            end
            default: operation =  4'b0000;
        endcase
    end
    
endmodule
