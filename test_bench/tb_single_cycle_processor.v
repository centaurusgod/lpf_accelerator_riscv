`timescale 1ns/1ps

module tb_single_cycle_processor;
    reg clk;
    reg reset;

    // 30,000 sample storage array
    reg [15:0] audio_samples [0:29999];
    integer sample_index;
    integer file_out;

    wire [31:0] result_of_alu;
    wire [31:0] address_of_pc;
    wire [31:0] next_pc_input;
    wire [31:0] instruction_from_ins_mem;

    single_cycle_processor dut (
        .clk(clk),
        .reset(reset),
        .result_of_alu(result_of_alu),
        .address_of_pc(address_of_pc),
        .alu_operation_cu(),
        .instruction_from_ins_mem(instruction_from_ins_mem),
        .immediate_value_from_imm_gen(),
        .source_register_one(),
        .source_register_two(),
        .destination_register(),
        .alu_source_a(),
        .alu_source_b(),
        .taking_branch(),
        .is_result_zero(),
        .next_branch_address(),
        .branch_flag_out(),
        .next_pc_input(next_pc_input),
        .dig_lpf_y_out()
    );

    // Clock generator (10ns period)
    always #5 clk = ~clk;

    // Setup, initial reset, and hex loading
    initial begin
        clk = 0;
        reset = 1;
        sample_index = 0;

        // Open target output file
        file_out = $fopen("single_lf.hex", "w");
        if (file_out == 0) begin
            $display("Error: Failed to open single_lf.hex for writing.");
            $finish;
        end

        // Read audio input samples
        $readmemh("audio_in.hex", audio_samples);

        // Instruction Memory Initialization (Word-indexed by PC/4)
        // Word 0 (PC 0x00): lui x3, 0x7
        dut.im.mem_cell[0] = 32'h000071b7;
        // Word 1 (PC 0x04): addi x3, x3, 1328    (28672 + 1328 = 30000)
        dut.im.mem_cell[1] = 32'h53018193;
        // Word 2 (PC 0x08): addi x7, x0, 1       (Decrement value)
        dut.im.mem_cell[2] = 32'h00100393;

        // LOOP: READ_AUDIO
        // Word 3 (PC 0x0C): sh x4, 0(x0)         (Write x4 to LPF @ 0x0)
        dut.im.mem_cell[3] = 32'h00401023;
        // Word 4 (PC 0x10): lh x5, 0(x0)         (Read y_out from LPF @ 0x0)
        dut.im.mem_cell[4] = 32'h00001283;
        // Word 5 (PC 0x14): sub x3, x3, x7       (x3 = x3 - 1)
        dut.im.mem_cell[5] = 32'h407181b3;
        // Word 6 (PC 0x18): bne x3, x0, -12      (Branch to PC 0x0C)
        dut.im.mem_cell[6] = 32'hfe019ae3;

        // Assert reset for 1 full clock cycle
        #10;
        reset = 0;
    end

    // Direct sample driver: Load current audio sample into x4 when the loop is about to execute.
    always @(negedge clk) begin
        if (!reset) begin
            if (address_of_pc == 32'h0c || address_of_pc == 32'h18) begin
                if (sample_index < 30000) begin
                    dut.reg_file.x[4] = {{16{audio_samples[sample_index][15]}}, audio_samples[sample_index]};
                end
            end
        end
    end

    // File Writer: Capture y_out from register x5 after the lh instruction executes at PC 0x10.
    always @(posedge clk) begin
        if (!reset) begin
            if (address_of_pc == 32'h10) begin
                #1; // Delay 1ns to wait for register file write-back to finish
                $fdisplay(file_out, "%04X", dut.reg_file.x[5][15:0]);
                sample_index = sample_index + 1;
            end
        end
    end

    // Simulation Monitor and Termination
    initial begin
        forever begin
            @(posedge clk);
            if (!reset && address_of_pc == 32'h18 && dut.reg_file.x[3] == 0) begin
                #20;
                $fclose(file_out);
                $display("\nSuccessfully processed %0d samples directly through LPF MMIO.", sample_index);
                $display("Output saved to single_lf.hex\n");
                $finish;
            end
        end
    end

endmodule
