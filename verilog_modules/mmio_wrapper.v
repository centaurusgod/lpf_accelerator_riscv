module mmio_wrapper (
    input [31:0] address,
    input [31:0] write_data,
    input [2:0] func3,
    // control signals
    input clk,
    input rst,
    input mem_write,
    input mem_read,

    output reg [31:0] read_data,

    // to simulate inside digitaljs only
    output wire signed [15:0] dig_lpf_y_out
);

    localparam LPF_ADDR = 32'h0000_0000;
    wire is_lpf_address = (address==LPF_ADDR);
    wire is_ram_address = !is_lpf_address;
    wire lpf_data_valid = mem_write && is_lpf_address;
    wire lpf_rst = write_data[16];

    wire signed [15:0] lpf_y_out;
    wire [31:0] ram_read_data;

    assign dig_lpf_y_out = lpf_y_out;

    data_memory dm(
        .clk(clk),
        .address(address),
        .mem_read(mem_read && is_ram_address),
        .mem_write(mem_write && is_ram_address),
        .write_data(write_data),
        .read_data(ram_read_data),
        .func3(func3)
    );

    // use write_data[15:0] as data input, as audio should be 16 bit PCM
    // I am thinking this approach might be wrong
    // because processor has to waste 2 bytes for noting
    // we will correct this later
    low_pass_filter lpf(
        .clk(clk),
        .x_in(write_data[15:0]),
        .data_valid(lpf_data_valid),
        .rst(rst),
        .y_out(lpf_y_out)
    );

    always @(*) begin
        if (mem_read) begin
            if (is_lpf_address) begin
                // sign extend 16 bit filtered output
                // problem may arise with sign (need to reject 2 bytes in memory and all)
                // should we export the audio in 32 bit instead?
                read_data = {{16{lpf_y_out[15]}}, lpf_y_out};
            end else begin
                read_data = ram_read_data;
            end
        end else begin
            read_data = 32'h0000_0000;
        end
    end
    
endmodule