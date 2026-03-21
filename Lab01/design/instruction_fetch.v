// datapath to fetch instruction
module instruction_fetch (
    output [31:0] instruction,
    input clk,
    input reset,

    // just to check ckt and val in digitaljs//remove after verification
    output [31:0] pc_display
);
    wire [31:0] pc_in;
    wire [31:0] pc_out;

    wire [31:0] pc_adder_out;


    program_counter pc(
        .clk(clk),
        .rst(reset),
        .pc_in(pc_adder_out),
        .pc_out(pc_out)
    );

    pc_adder pca(
        .a(pc_out),
        .out(pc_adder_out)
    );

    ins_mem imm(
        .address(pc_out),
        .instruction(instruction)
    );

    assign pc_display = pc_out;
    
endmodule