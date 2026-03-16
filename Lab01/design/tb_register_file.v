`timescale 1ns/1ps
`include "register_file.v"

module tb_register_file;
    reg clk;
    reg rst;

    reg [31:0] write_data;
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    reg reg_write;

    wire [31:0] read_data1;
    wire [31:0] read_data2;

    always #10 clk = ~clk; //maybe using this clk, it'll will be harder for me to track the change in ip/op

    register_file uut
    (
        .clk(clk),
        .rst(rst),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_data),
        .reg_write(reg_write),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

  initial begin
    $dumpfile("tb_register_file.vcd");
    $dumpvars(0, tb_register_file);

    clk =0;

    // case 1: test write (write values on reg21 and reg 22)
    rst = 1;
    #20;
    rst = 0;
    rd = 5'd21;
    write_data = 32'hcccccccc;
    reg_write = 1;
    #20;

    rd = 5'd22;
    write_data = 32'hdddddddd;
    #20; // wait for write to take effect

    // initialize garbage into write
    write_data  = 32'bx;
    // stop writing to register file
    reg_write = 0;
    #20;

    // case 2: read the in rs1 and rs2 and check values
    rs1 = 5'd21;
    rs2 = 5'd22;
    #20;


    // case 3: test reset (should reset x21 and x22 to 0)
    rst = 1;
    #20;
     rst = 0;
    rs1 = 5'd21;
    rs2 = 5'd22;
    #20;

    $finish;

  end

    initial begin
        $monitor("Time: %0t | rs1: %d | rs2: %d | rd: %d | reg_write: %d | rst: %d | write_data: 0x%h | read_data1: 0x%h | read_data2: 0x%h", $time, rs1, rs2, rd, reg_write, rst, write_data, read_data1, read_data2);
    end

endmodule