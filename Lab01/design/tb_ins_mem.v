`timescale 1ns/1ps
// `include "ins_mem.v"
`default_nettype none

module tb_ins_mem;
    reg [31:0] address;
    wire [31:0] instruction;

    ins_mem uut (
        .instruction(instruction),
        .address(address)
    );

    // initialize 16 bytes values into the instruction memory
    initial begin
        $readmemh("instruction_mem_initialize.hex", uut.mem_cell);
    end

    initial begin
        $dumpfile("tb_ins_mem.vcd");
        $dumpvars(0, tb_ins_mem);
    end



    initial begin
        address = 0;
        #10 address = 4;
        #10 address = 8;
        #10 address = 12;
        #10 $finish(2);
    end

    // print the address and instruction value at each change of address
    always @(address) begin
         #1;
        $display("Address: %h, Instruction: %h", address, instruction);
    end

    integer i;
    initial begin
        for (i = 0; i < 16; i = i + 1)
            $display("mem[%0d] = %h", i, uut.mem_cell[i]);
    end

endmodule
`default_nettype wire