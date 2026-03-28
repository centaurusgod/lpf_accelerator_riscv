// module ins_mem (
//     output reg [31:0] instruction,
//     input [31:0] address
// );

//     reg [7:0] mem_cell [63:0];



//     always @(*) begin
//         instruction = {mem_cell[address+3], mem_cell[address+2], mem_cell[address+1], mem_cell[address]};
//     end
    
// endmodule


// just for visualizing in digitaljs
// integer i;
module ins_mem (
    output reg [31:0] instruction,
    input [31:0] address
);

    always @(*) begin
        case (address)
            // addi x1, x0, 2
            // sw x1, 0(x0)
            // lw x2, 0(x0)
            // add x1, x1, x2
            32'h00: instruction = 32'h00200093;
            32'h04: instruction = 32'h00102023;
            32'h08: instruction = 32'h00002103;
            32'h0C: instruction = 32'h002080b3;


            
            // Default to NOP (addi x0, x0, 0) for all other addresses
            // This prevents 'x' from entering your datapath
            default: instruction = 32'h00000013; 
        endcase
    end
    
endmodule
