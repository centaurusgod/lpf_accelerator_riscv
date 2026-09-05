`timescale 1ns/1ps

module tb_low_pass_filter;

    // Signal Declarations
    reg clk;
    reg rst;
    reg data_valid;
    reg signed [15:0] x_in;
    wire signed [15:0] y_out;

    // 3 seconds at 10,000 Hz = 30,000 samples
    parameter NUM_SAMPLES = 30000;
    reg [15:0] audio_mem [0:NUM_SAMPLES-1];

    integer i;
    integer file_out;

    // Instantiate Unit Under Test (DUT)
    low_pass_filter uut (
        .clk(clk),
        .rst(rst),
        .data_valid(data_valid),
        .x_in(x_in),
        .y_out(y_out)
    );

    // Clock Generator: 100 MHz clock (10 ns period)
    always #5 clk = ~clk;

    initial begin
        // 1. Initialize control and data signals
        clk = 0;
        rst = 1;
        data_valid = 0;
        x_in = 0;

        // 2. Load input hex file into memory array
        $readmemh("audio_in.hex", audio_mem);

        // 3. Open output file for logging filtered hex samples
        file_out = $fopen("sept_4_audio_out.hex", "w");

        // Release reset after 20 ns
        #20;
        rst = 0;
        @(posedge clk);

        // 4. Stream audio samples into DUT sample-by-sample
        for (i = 0; i < NUM_SAMPLES; i = i + 1) begin
            // Drive new input sample on clock edge
            @(posedge clk);
            x_in <= audio_mem[i];
            data_valid <= 1'b1;

            // Deassert data_valid on the following clock cycle
            @(posedge clk);
            data_valid <= 1'b0;

            // Wait 1 time unit to let registers settle before logging output sample
            #1;
            $fwrite(file_out, "%04X\n", y_out & 16'hFFFF);
        end

        // 5. Close output log and finish simulation
        $fclose(file_out);
        $display("Simulation complete! Successfully processed %0d samples.", NUM_SAMPLES);
        $finish;
    end

endmodule