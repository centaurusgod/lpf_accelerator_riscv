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
            32'h00: instruction = 32'h06400113; // addi x2, x0, 100
            32'h04: instruction = 32'h00000093; // addi x1, x0, 0
            32'h08: instruction = 32'h00108093; // loop: addi x1, x1, 1
            32'h0C: instruction = 32'h00208663; // beq x1, x2, +8  (to done)
            32'h10: instruction = 32'hFE000CE3; // beq x0, x0, -8  (to loop)
            32'h14: instruction = 32'h00000013; // done: nop
            
            // Default to NOP (addi x0, x0, 0) for all other addresses
            // This prevents 'x' from entering your datapath
            default: instruction = 32'h00000013; 
        endcase
    end
    
endmodule

// write all the memory instantiation address logic here

// 1. Test for alu result by adding immediate values
            // 32'd0  : instruction = 32'h01900093; // addi x1, x0, 25
            // 32'd4  : instruction = 32'h03200113; // addi x2, x0, 50
            // 32'd8  : instruction = 32'h00A08193; // addi x3, x1, 10

// 2. Test for subtraction operation
// first load the immediate values into the register by performing add
            // 32'd0  : instruction = 32'h01900093; // addi x1, x0, 100
            // 32'd4  : instruction = 32'h03200113; // addi x2, x0, 90
            // 32'd8  : instruction = 32'b00000000; // sub x3, x1, x2 (result should be 10)

// 3. test for loop
            // 32'h00: instruction = 32'h06400113; // addi x2, x0, 100
            // 32'h04: instruction = 32'h00000093; // addi x1, x0, 0
            // 32'h08: instruction = 32'h00108093; // loop: addi x1, x1, 1
            // 32'h0C: instruction = 32'hFE20CEE3; // blt x1, x2, loop (Offset -4)