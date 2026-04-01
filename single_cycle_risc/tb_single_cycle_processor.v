`timescale 1ns / 1ps

module tb_single_cycle_processor;

    // Inputs
    reg clk;
    reg reset;

    // Outputs
    wire [31:0] address_of_pc;
    wire [31:0] result_of_alu;

    // Dummy wires for unused outputs
    wire [3:0] alu_operation_cu;
    wire [31:0] instruction_from_ins_mem;
    wire [31:0] immediate_value_from_imm_gen;
    wire [4:0] source_register_one;
    wire [4:0] source_register_two;
    wire [4:0] destination_register;
    wire [31:0] alu_source_a;
    wire [31:0] alu_source_b;
    wire taking_branch;
    wire is_result_zero;
    wire [31:0] next_branch_address;
    wire branch_flag_out;
    wire [31:0] next_pc_input;

    // Instantiate DUT
    single_cycle_processor uut (
        .clk(clk),
        .reset(reset),
        .result_of_alu(result_of_alu),
        .address_of_pc(address_of_pc),
        .alu_operation_cu(alu_operation_cu),
        .instruction_from_ins_mem(instruction_from_ins_mem),
        .immediate_value_from_imm_gen(immediate_value_from_imm_gen),
        .source_register_one(source_register_one),
        .source_register_two(source_register_two),
        .destination_register(destination_register),
        .alu_source_a(alu_source_a),
        .alu_source_b(alu_source_b),
        .taking_branch(taking_branch),
        .is_result_zero(is_result_zero),
        .next_branch_address(next_branch_address),
        .branch_flag_out(branch_flag_out),
        .next_pc_input(next_pc_input)
    );

    always #5 clk = ~clk;

    initial begin

        // hex -> instuctions mapping log is present in test_instructions/hex/ins_mem_loads.log

        // load instructions into instruction memory
        //$readmemh("test_instructions_hex/sw_lw.hex", uut.im.mem_cell);

        // load instructions for beq
        // $readmemh("test_instructions_hex/beq.hex", uut.im.mem_cell);

        // load instructions for bge
        // $readmemh("test_instructions_hex/bge.hex", uut.im.mem_cell);

        // load instructions for blt
       // $readmemh("test_instructions_hex/blt.hex", uut.im.mem_cell);

        // load instructions for bltu
        // $readmemh("test_instructions_hex/bltu.hex", uut.im.mem_cell);

        // instructions for bgeu
        //$readmemh("test_instructions_hex/bgeu.hex", uut.im.mem_cell);


    end

    always @(posedge clk) begin
        $display("Time = %0t | PC = %h | Instruction = %h | Funct3 = %b | ALU Result = %d | CU Branch: %b |  Branch Control Unit: %b", 
                  $time, address_of_pc, instruction_from_ins_mem, instruction_from_ins_mem[14:12], result_of_alu, taking_branch, branch_flag_out);

        // test for load and store instructions
        // only display instructions, and (ALU RESULT | Data Memory Address)
            // $display("Time = %0t | PC = %h | Instruction = %h | (ALU Result , Data Memory Address) = %d", 
            //         $time, address_of_pc, instruction_from_ins_mem, result_of_alu);
    end

    // Test sequence
    initial begin
        clk = 0;
        reset = 1;

        #15;
        reset = 0;

        #1000;

        $finish;
    end

endmodule