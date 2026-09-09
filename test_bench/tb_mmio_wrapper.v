`timescale 1ns / 1ps

module tb_mmio_wrapper;

    // Inputs
    reg [31:0] address;
    reg [31:0] write_data;
    reg clk;
    reg rst;
    reg mem_write;
    reg mem_read;

    // Outputs
    wire [31:0] read_data;
    wire signed [15:0] dig_lpf_y_out;
    integer y_after_first_input;
    integer y_after_second_input;

    // Instantiate the Unit Under Test (UUT)
    mmio_wrapper uut (
        .address(address),
        .write_data(write_data),
        .clk(clk),
        .rst(rst),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .read_data(read_data),
        .dig_lpf_y_out(dig_lpf_y_out)
    );

    // Clock generation (100MHz -> 10ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize Signals
        clk = 0;
        rst = 1;
        address = 32'h0;
        write_data = 32'h0;
        mem_write = 0;
        mem_read = 0;

        // Global System Reset
        #10;
        rst = 0;
        #10;

        // ----------------------------------------------------------------
        // STEP 1: Select LPF address (0x0000_0000) and issue LPF reset signal
        // bit 16 of write_data sets lpf_rst high when mem_write is enabled
        // ----------------------------------------------------------------
        $display("[%0t ns] STEP 1: Resetting LPF via MMIO Address 0x0000_0000...", $time);
        address   = 32'h0000_0000;
        write_data = 32'h0001_0000; // write_data[16] = 1 (lpf_rst)
        mem_write  = 1'b1;
        mem_read   = 1'b0;
        
        #10; // Hold for 1 clock cycle
        mem_write  = 1'b0;
        #10;

        // ----------------------------------------------------------------
        // STEP 2: Provide the same signed 12544 (16'sd12544) value to the LPF
        // on the next cycle so the filter sees the same x_in twice.
        // ----------------------------------------------------------------
        $display("[%0t ns] STEP 2: Writing signed 12544 (0x3100) to LPF for two consecutive cycles...", $time);
        address   = 32'h0000_0000;
        // write_data[15:0] = 12544 (16'h3100), write_data[16] = 0 (no reset)
        write_data = {16'h0000, 16'sd12544}; 
        mem_write  = 1'b1;

        #10;
        mem_write  = 1'b0;
        #10;
        y_after_first_input = $signed(dig_lpf_y_out);
        $display("  After first x_in = %0d, y_out = %0d", $signed(write_data[15:0]), y_after_first_input);

        // provide the same x_in value again on the next cycle
        write_data = {16'h0000, 16'sd12544};
        mem_write  = 1'b1;
        #10;
        mem_write  = 1'b0;
        #10;
        y_after_second_input = $signed(dig_lpf_y_out);
        $display("  After second x_in = %0d, y_out = %0d", $signed(write_data[15:0]), y_after_second_input);
        
        // Wait a few clock cycles for the filter pipeline to process
        #30;

        // Read back output via MMIO bus to trigger dig_lpf_y_out logic
        mem_read = 1'b1;
        #10;

        // Display results
        $display("----------------------------------------");
        $display("Output Results:");
        $display("  First input y_out  = %0d", y_after_first_input);
        $display("  Second input y_out = %0d", y_after_second_input);
        $display("  dig_lpf_y_out (Decimal) = %0d", $signed(dig_lpf_y_out));
        $display("  dig_lpf_y_out (Hex)     = 0x%h", dig_lpf_y_out);
        $display("  Bus Read Data (Decimal) = %0d", $signed(read_data));
        $display("  Bus Read Data (32-bit)  = 0x%h", read_data);
        $display("----------------------------------------");

        #10;
        $finish;
    end

endmodule