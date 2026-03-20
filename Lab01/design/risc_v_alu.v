//32 bit riscv alu
// to-do read docs and perhaps add barrel shifter, and more logical operations like xor, nor, not etc.
module risc_v_alu (
    input [31:0] a,
    input [31:0] b,
    input a_invert,
    input b_invert,
    input [3:0] alu_op,
    output reg [31:0] result,
    output reg c_out,
    output reg zero
);
    // trick to get the value of c_out from MSB
    // we will use MSB to calculate c_out, result = [31:0] tmp_result 
    reg [32:0] tmp_result;

    wire [31:0] a_final;
    wire [31:0] b_final;

    assign a_final = a_invert ? ~a : a;
    assign b_final = b_invert ? ~b : b;
   


   // for testing, just use 0000 for addition and 0001 for subtraction
   // 0010 for and and 0011 for or
   // later modify the case block to include actual opcodes from instructions decoder and control unit
   // for revise the actual bits that comes to alu through control unit and write operations based on it

    always @(*) begin

        c_out = 1'b0;
        tmp_result = 33'b0;

        case (alu_op)
            // add and sub is handled in single block (guided by b_invert)
            4'b0000 : begin
                // cin to lsb = b_invert
                tmp_result = {1'b0, a_final} + {1'b0, b_final} + b_invert;
                result = tmp_result[31:0];
                c_out = tmp_result[32];
            end
            4'b0010 : begin
                result = a_final & b_final;
            end
            4'b0011 : begin
                result = a_final | b_final;
                
            end
            default: begin
                result = 32'bx;
                c_out = 1'bx;
                zero = 1'bx;
            end 
        endcase

        zero = (result==32'b0);
    
    end

endmodule