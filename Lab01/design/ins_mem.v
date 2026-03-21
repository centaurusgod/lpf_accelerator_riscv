module ins_mem (
    output reg [31:0] instruction,
    input [31:0] address
);

    reg [7:0] mem_cell [15:0];

    always @(*) begin
        instruction = {mem_cell[address+3], mem_cell[address+2], mem_cell[address+1], mem_cell[address]};
    end
    
endmodule