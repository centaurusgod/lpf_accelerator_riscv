module pc_updater (
    input clk,
    input rst,
    output [31:0] next_pc
);
    wire [31:0] pc_out;

    program_counter pc(
        .clk(clk),
        .rst(rst),
        .pc_in(next_pc),
        .pc_out(pc_out)
    );

    address_adder adder(
        .a(pc_out),
        .b(3'b100),
        .out(next_pc)
    );
    
endmodule