module single_cycle_processor (
    input clk,
    input reset,
    output [31:0] result_of_alu,
    output [31:0] address_of_pc,
    output [3:0] alu_operation_cu,
    output [31:0] instruction_from_ins_mem,
    output [31:0] immediate_value_from_imm_gen,
    output [4:0] source_register_one,
    output [4:0] source_register_two,
    output [4:0] destination_register,

    output [31:0] alu_source_a,
    output [31:0] alu_source_b,

    output taking_branch,
    output is_result_zero,

    output [31:0] next_branch_address,

    output branch_flag_out,

    output [31:0] next_pc_input

);

    wire [31:0] pc_in;
    wire [31:0] pc_out;

    // instruction  memory
    wire [31:0] instruction;

    // instruction decoder
    wire [6:0] opcode;
    wire [4:0] rd;
    wire [2:0] func3;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [6:0] func7;

    // reg_file
    wire [31:0] write_reg;
    wire reg_write;
    wire [31:0] read_data1;
    wire [31:0] read_data2;

    // immediate data generator
    // 12 -> 32 bit sign extended immediate data
    wire[31:0] imm_data;

    // control unit
    // mux control signal to decide alu src is either reg or immediate value
    wire branch;
    wire mem_read;
    wire mem_to_reg;
    wire [1:0] alu_op;
    wire mem_write;
    wire alu_src;

    // alu
    wire [31:0] alu_src_mux_out;
    wire [31:0] alu_result;
    wire c_out;
    wire zero_flag;
    wire overflow_flag;
    wire sign_flag;

    // alu_control
    // alu_op is for control units, alu_operation is for alu
    // naming should be improved
    wire [3:0] alu_operation;

    // o/p from data memory
    wire [31:0] read_data;

    // op from branch address adders
    wire [31:0] branch_address;
    wire [31:0] next_pc;

    // output from branch control unit
    wire branch_flag;

    // and gate  perform_branch = branch & zero_flag_from_alu
    wire perform_branch;

    // control unit
    control_unit cu(
        .opcode(opcode),
        .branch(branch),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .reg_write(reg_write),
        .alu_src(alu_src)
    );

    program_counter pc(
        .clk(clk),
        .rst(reset),
        .pc_in(pc_in),
        .pc_out(pc_out)
    );

    // pc = pc + 4
    // each instruction 32bit/4bytes long
    address_adder pc_add(
        .a(pc_out),
        .b(32'h4),
        .out(next_pc)
    );

    ins_mem im(
        .address(pc_out),
        .instruction(instruction)
    );

    instruction_decoder i_d(
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .func3(func3),
        .rs1(rs1),
        .rs2(rs2),
        .func7(func7)
    );
    
    register_file reg_file(
        .clk(clk),
        .rst(reset),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_reg),
        .reg_write(reg_write),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    imm_data_gen immdata_gen(
        .instruction(instruction),
        .imm_data(imm_data)
    );

    // data source for alu
    // either to come from register or immediate data gen
    mux reg_or_imm_data_selector(
        .a(read_data2),
        .b(imm_data),
        .sel(alu_src),
        .data_out(alu_src_mux_out)
    );

    alu_control alu_cu(
        .alu_op(alu_op),
        .funct({instruction[30], instruction[14:12]}),
        .operation(alu_operation)
    );

    risc_v_alu alu(
        .a(read_data1),
        .b(alu_src_mux_out),
        .alu_op(alu_operation),
        .result(alu_result),
        .overflow_flag(overflow_flag),
        .c_out(c_out),
        .zero_flag(zero_flag),
        .sign_flag(sign_flag)
    );

    assign alu_source_a = read_data1;
    assign alu_source_b = alu_src_mux_out;

    data_memory dm(
        .address(alu_result),
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .write_data(read_data2),
        .read_data(read_data)
    );

    // either to save value from data memory like lw instruction
    // for from the alu directly to the register like add, sub instruction
    mux write_back_selector(
        .sel(mem_to_reg),
        // data read from data_mem
        .b(read_data),
        // result from alu
        .a(alu_result),
        .data_out(write_reg)
    );

    // for branch instructions
    // though we can do via code, but better modulize it
    address_adder branch_address_adder(
        .a(pc_out),
        .b(imm_data),
        .out(branch_address)
    );

    // branch control unit
    branch_control bcu_uut(
        .zero_flag(zero_flag),
        .overflow_flag(overflow_flag),
        .c_out(c_out),
        .sign_flag(sign_flag),
        .func3(func3),
        .branch_flag(branch_flag)
    );

    assign perform_branch = branch & branch_flag;
    
    // decides to update the pc=pc+4, or a branch address
    mux pc_update_selector(
        .sel(perform_branch),
        .a(next_pc),
        .b(branch_address),
        .data_out(pc_in)
    ); 

    assign branch_flag_out = branch_flag;
    //assign taking_branch = perform_branch;
    assign taking_branch = branch;
    assign is_result_zero = zero_flag;
    assign next_branch_address =  branch_address;
    assign alu_operation_cu = alu_operation;
    assign result_of_alu = alu_result;
    assign address_of_pc = pc_out;
    assign instruction_from_ins_mem = instruction;
    assign immediate_value_from_imm_gen = imm_data;
    assign source_register_one = rs1;
    assign source_register_two = rs2;
    assign destination_register = rd;
    assign next_pc_input = pc_in;

    
endmodule