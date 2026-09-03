module data_memory (
    input [31:0] address,
    input [31:0] write_data,
    input [2:0] func3,
    // control signals
    input clk,
    input mem_write,
    input mem_read,

    output reg [31:0] read_data
);

    // 1 x n byte module
    // For LPF (increase it to at least 60k bytes to store the output, Using 64KB)
    reg [7:0] mem_cell  [0:65536];

    // load the first 30000 samples into the memory
    

    // synchronous write
    always @(posedge clk) begin
        if(mem_write) begin
            case (func3)
                3'b000: begin // sb
                    mem_cell[address] <= write_data[7:0];
                end
                3'b001: begin // sh
                    mem_cell[address] <= write_data[7:0];
                    mem_cell[address+1] <= write_data[15:8];
                end
                3'b010: begin // sw
                    mem_cell[address] <= write_data[7:0];
                    mem_cell[address+1] <= write_data[15:8];
                    mem_cell[address+2] <= write_data[23:16];
                    mem_cell[address+3] <= write_data[31:24];    
                end
                default: begin
                    // do nothing
                end
            endcase
        end
    end

    // asynchronous read
    always @(*) begin
        if (mem_read) begin
            case (func3)
                3'b000: begin // lb
                    read_data = {{24{mem_cell[address][7]}}, mem_cell[address]};
                end
                3'b001: begin // lh
                    read_data = {{16{mem_cell[address+1][7]}}, mem_cell[address+1], mem_cell[address]};
                end
                3'b010: begin // lw
                    read_data = {mem_cell[address+3], mem_cell[address+2], mem_cell[address+1], mem_cell[address]};
                end
                default: begin
                    read_data = 32'b0;
                end
            endcase
        end else begin
            read_data = 32'b0;
        end
    end
    
endmodule