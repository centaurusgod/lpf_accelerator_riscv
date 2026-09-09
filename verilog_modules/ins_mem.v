module ins_mem (
    output [31:0] instruction,
    input [31:0] address
);
    reg [31:0] mem_cell [0:31];
    assign instruction = mem_cell[address >> 2];

endmodule
