`timescale 1ns/1ps
`include "instruction_decoder.v"
`default_nettype none

module tb_instruction_decoder;
    reg [31:0] instruction;
    wire [6:0] opcode;
    wire [4:0] rd;
    wire [2:0] func3;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [6:0] func7;

    instruction_decoder uut
    (
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .func3(func3),
        .rs1(rs1),
        .rs2(rs2),
        .func7(func7)
    );

    initial begin
        $dumpfile("tb_instruction_decoder.vcd");
        $dumpvars(0, tb_instruction_decoder);

        // Test cases
        // Inst Name FMT Opcode funct3 funct7 Description (C) Note
        // add ADD R 0110011 0x0 0x00 rd = rs1 + rs2
        // sub SUB R 0110011 0x0 0x20 rd = rs1 - rs2
        // xor XOR R 0110011 0x4 0x00 rd = rs1 ˆ rs2
        // or OR R 0110011 0x6 0x00 rd = rs1 | rs2
        // and AND R 0110011 0x7 0x00 rd = rs1 & rs2
        // sll Shift Left Logical R 0110011 0x1 0x00 rd = rs1 << rs2
        // srl Shift Right Logical R 0110011 0x5 0x00 rd = rs1 >> rs2
        // sra Shift Right Arith* R 0110011 0x5 0x20 rd = rs1 >> rs2 msb-extends
        // slt Set Less Than R 0110011 0x2 0x00 rd = (rs1 < rs2)?1:0
        // sltu Set Less Than (U) R 0110011 0x3 0x00 rd = (rs1 < rs2)?1:0 zero-extends
        // using x20 for destination x21 as source 1 and x22 as source 2 for all test cases
        instruction = 32'b0000000_10110_10101_000_10100_0110011; // add x20, x21, x22
        #10;
        instruction = 32'b0100000_10110_10101_000_10100_0110011; // sub x20, x21, x22
        #10;
        instruction = 32'b0000000_10110_10101_100_10100_0110011; // xor x20, x21, x22
        #10;
        instruction = 32'b0000000_10110_10101_110_10100_0110011; // or x20, x21, x22
        #10;
        instruction = 32'b0000000_10110_10101_111_10100_0110011; // and x20, x21, x22
        #10;
        instruction = 32'b0000000_10110_10101_001_10100_0110011; // sll x20, x21, x22
        #10;
        instruction = 32'b0000000_10110_10101_101_10100_0110011; // srl x20, x21, x22
        #10;
        instruction = 32'b0100000_10110_10101_101_10100_0110011; // sra x20, x21, x22
        #10;
        instruction = 32'b0000000_10110_10101_010_10100_0110011; // slt x20, x21, x22
        #10;
        instruction = 32'b0000000_10110_10101_011_10100_0110011; // sltu x20, x21, x22
        #10;
        $finish;
    end

endmodule
`default_nettype wire