//32 bit riscv alu
// to-do read docs and perhaps add barrel shifter, and more logical operations like xor, nor, not etc.
module risc_v_alu (
    input [31:0] a,
    input [31:0] b,
    input [3:0] alu_op,
    
    output reg [31:0] result,
    output reg c_out,
    output reg zero_flag,
    output reg overflow_flag,
    output reg sign_flag
);
    // trick to get the value of c_out from MSB
    // we will use MSB to calculate c_out, result = [31:0] tmp_result 
    reg [32:0] tmp_result;

    wire [31:0] a_final;
    wire [31:0] b_final;
    wire a_invert;
    wire b_invert;

    // 3rd bit of alu_op may indicate subtraction operation
    assign b_invert = alu_op[2];
    assign a_invert = 1'b0;

    assign a_final = a_invert ? ~a : a;
    assign b_final = b_invert ? ~b : b;   


   // for testing, just use 0000 for addition and 0001 for subtraction
   // 0010 for and and 0011 for or
   // later modify the case block to include actual opcodes from instructions decoder and control unit
   // for revise the actual bits that comes to alu through control unit and write operations based on it

    always @(*) begin
        tmp_result = 33'b0;
        c_out = 1'b0;

        case (alu_op)
            // add and sub is handled in single block (guided by b_invert)
            4'b0010, 4'b0110 : begin
                // cin to lsb = b_invert
                tmp_result = {1'b0, a_final} + {1'b0, b_final} + b_invert;
                result = tmp_result[31:0];
                c_out = tmp_result[32];
            end
            4'b0000 : begin
                result = a_final & b_final;
            end
            4'b0011 : begin
                result = a_final | b_final;
                
            end
            default: begin
                result = 32'b0;
                c_out = 1'b0;
            end 
        endcase

        // if both number have same sign,
        // but the result is having different sign than the inputs
        // overflow currently being used for branch instruction only (so sub)
        overflow_flag = (a[31]==b_final[31]) && (result[31]!=a[31]);
        zero_flag = (result==32'b0);
        sign_flag = result[31];
    
    end

endmodule