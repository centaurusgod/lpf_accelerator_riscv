module control_unit (
    input [6:0] opcode,

    output reg branch,
    output reg  mem_read,
    output reg mem_to_reg,
    output reg [1:0] alu_op,
    output reg mem_write,
    output reg alu_src,
    output reg reg_write
);

    always @(*) begin
        case (opcode)
        // r type
            7'b0110011 : begin
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                reg_write = 1'b1;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                alu_op = 2'b10;
            end

            // I-type id
            7'b0000011 : begin
                alu_src = 1'b1;
                mem_to_reg = 1'b1;
                reg_write = 1'b1;
                mem_read = 1'b1;
                mem_write = 1'b0;
                branch = 1'b0;
                alu_op =  2'b00;
            end

            // I-type sd
            7'b0100011 : begin
                alu_src = 1'b1;
                mem_to_reg = 1'bx;
                reg_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b1;
                branch = 1'b0;
                alu_op =  2'b00;
            end
            // Sb Type (beq)
            7'b1100011 : begin
                alu_src = 1'b0;
                mem_to_reg = 1'bx;
                reg_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b1;
                alu_op =  2'b01;
            end
            default: begin
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                reg_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                alu_op = 2'b00;
            end
        endcase
    end
    
endmodule