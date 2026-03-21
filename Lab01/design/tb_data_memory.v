`timescale 1ns/1ps
`include "data_memory.v"
`default_nettype none

module tb_data_memory;
    reg clk;
    reg [31:0] address;
    reg [31:0] write_data;
    wire [31:0] read_data;
    
    reg mem_read;
    reg mem_write;

    data_memory uut
    (
        .clk(clk),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
    );

    initial clk = 0;
    always #10 clk = ~clk;

    // load data_memory_init.hex into memory
    initial begin
        $readmemh("data_memory_init.hex", uut.mem_cell);
    end

    integer i;

    initial begin
        mem_read=0;
        mem_write=0;
        address=0;
        write_data=0;

        @(negedge clk);



        // read pre-loaded values from mem
        mem_read = 1;
        address = 0; #20;
        address = 4; #20;
        address = 8; #20;
        address = 12; #20;

        // deassert read, assert write
        #20;
        mem_read = 0;
        mem_write = 1;

        // write new values to mem
        // write data in descending order from hex: 10 to 01
        
        write_data = 32'h100f0e0d;
        address = 0; #20;

        write_data = 32'h0c0b0a09;
        address = 4; #20;

        write_data = 32'h08070605;
        address = 8; #20;

        write_data = 32'h04030201;
        address = 12; #20;

        // read back the new values
        #20;
        mem_write = 0;
        mem_read = 1;
        address = 0; #20;
        address = 4; #20;
        address = 8; #20;
        address = 12; #20;

        $finish;

    end

    initial begin
        $monitor("Time: %0t | Address: %h | MR: %b | MW: %b | O/P: %h", $time, address, mem_read, mem_write, read_data);
    end


endmodule
`default_nettype wire