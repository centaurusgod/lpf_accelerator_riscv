module top_control (
    input [6:0] opcode,
    input [3:0] funct,
    
    output branch,
    output mem_read,
    output mem_to_reg,
    output mem_write,
    output alu_src,
    output reg_write,
    output [3:0] operation

);

    wire [1:0] alu_op;

    control_unit cu(
        .opcode(opcode),
        .branch(branch),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write)
    );

    alu_control alu_cu(
        .alu_op(alu_op),
        .funct(funct),
        .operation(operation)
    );
    
endmodule