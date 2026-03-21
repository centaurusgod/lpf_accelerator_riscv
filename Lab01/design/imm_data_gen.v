/*
a module which takes the 32-bit input instruction and extracts the 12-bit immediate
data field depending on the type of instruction (I, S, B, U, J) and outputs the sign-extended 32-bit immediate data
*/
module imm_data_gen (
    input [31:0] instruction,
    output reg [31:0] imm_data
);
    // fmt, opcode
    // I, 0010011, 0000011
    // S, 0100011
    // B, 1100011
    // U, 0110111 
    // J, 1101111
    wire [6:0] opcode;
    wire [31:20] imm_i;
    assign opcode = instruction[6:0];

    //00000010000010101000101000010011

    always @(*) begin
        imm_data = 32'b0;
        case (opcode)
            // I-type and load instructions
            7'b0010011, 7'b0000011: imm_data = {{20{instruction[31]}}, instruction[31:20]};

            // S-type instructions
            7'b0100011: imm_data = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};

            // U-type instructions
            7'b0110111, 7'b0010111: imm_data = {instruction[31:12], 12'b0};
            
            // https://youtu.be/bfL_ps7edK4?list=PLq5K7Zq6zbGO2OO7Y9a7h0iEWK5gDYw_q
            // B-type instructions
            7'b1100011: imm_data = {
                {20{instruction[31]}}, //12thbit sign extended
                instruction[31], //12 bit
                instruction[7], //11th bit
                instruction[30:25], // 10-5 bits
                instruction[11:8], // 4-1 bits
                1'b0 // 0th bit just appended
            };

            // J-type instructions
            7'b1101111: imm_data = {
                {20{instruction[31]}}, // 20-bit sign extension
                instruction[31], // 12th bit
                instruction[19:12], // 19-12 bits
                instruction[20], // 11th bit
                instruction[30:21], // 10-1 bits
                1'b0 
            };
            
            default: imm_data = 32'b0;
        endcase

    end

    //// addi x20, x21, 32
   // 0000001 00000 10101 000 10100 0010011
   // 00000010000010101000101000010011


    
endmodule