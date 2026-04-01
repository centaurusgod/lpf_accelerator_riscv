module data_memory (

    input [31:0] address,
    input [31:0] write_data,

    output reg [31:0] read_data,

    // control signals
    input clk,
    input mem_write,
    input mem_read
);

    // 1 x n byte module
    reg [7:0] mem_cell  [0:63];

    // synchronous write
    always @(posedge clk) begin
        if(mem_write) begin
        mem_cell[address] <= write_data[7:0];
        mem_cell[address+1] <=  write_data[15:8];
        mem_cell[address+2] <= write_data[23:16];
        mem_cell[address+3] <=  write_data[31:24];    
        end
    end

    // asynchronous read
    always @(*) begin
        if (mem_read) begin
            read_data = {
                mem_cell[address+3], mem_cell[address+2], mem_cell[address+1], mem_cell[address]
            };
        end else begin
            read_data = 32'b0;
        end
    end
    
endmodule