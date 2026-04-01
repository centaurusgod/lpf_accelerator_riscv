module branch_control (
   input zero_flag,
    input overflow_flag,
    // 31st bit from ALU
    input sign_flag,
    input c_out,
    input [2:0] func3,

    // output branch_flag
    output reg branch_flag
);
    
    always @(*) begin
        case (func3)
            // beq instruction;
            // if result of alu is zero then branch
            3'b000 : begin
                branch_flag = (zero_flag == 1'b1);
            end

            // bne instruction
            3'b001 : begin
                branch_flag = (zero_flag == 1'b0);
            end

            // blt instruction (signed)
            // if overflow_flag and sign are alternate means result is true otherwise false
            3'b100 : begin
                branch_flag = sign_flag ^ overflow_flag;
            end

            // bge instruction (signed)
            3'b101 : begin
                branch_flag = ~(sign_flag ^ overflow_flag);
            end

            //bltu (unsigned)
            3'b110 : begin
                branch_flag = (c_out==1'b0);
            end

            // bgeu (unsigned)
            // greater or equal to unsigned
            3'b111 : begin
                branch_flag = (c_out==1'b1);
            end

            default: branch_flag = 1'b0;
        endcase
    end

endmodule