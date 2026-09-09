module low_pass_filter(
    // 16 bit input
    // We assume we save the audio in 16 bit signed int notation in the wav file
    input signed [15:0] x_in,
    input rst,
    input wire data_valid,
    input wire clk,
    output reg signed[15:0] y_out
);

    // difference Const Coefficients (Pre-negated in Q2.14)
    // localparam signed [15:0] b0 = 16'sd15;      //  0.00094469 * 16384
    // localparam signed [15:0] b1 = 16'sd31;      //  0.00188938 * 16384
    // localparam signed [15:0] b2 = 16'sd15;      //  0.00094469 * 16384
    // localparam signed [15:0] a1 = 16'sd31313;   // -(-1.911197) * 16384 (Pre-negated -> Direct)
    // localparam signed [15:0] a2 = -16'sd14991;  // -(+0.914976) * 16384 (Pre-negated -> 2's Complement)

    localparam signed [15:0] b0 = 16'sb0000000000001111; // 15
    localparam signed [15:0] b1 = 16'sb0000000000011111; // 31
    localparam signed [15:0] b2 = 16'sb0000000000001111; // 15
    localparam signed [15:0] a1 = 16'sb0111101001010001; // 31313
    localparam signed [15:0] a2 = 16'sb1100010101110001; // -14991

    // Delay registers x & y
    reg signed [15:0] x_1;
    reg signed [15:0] x_2;
    reg signed [15:0] y_1;
    reg signed [15:0] y_2;

    // We have audio input as 16bit signed integer val, but input is unsigned
    // so convert the x_in to signed
    wire signed [31:0] p0 = x_in * b0;
    wire signed [31:0] p1 = x_1  * b1;
    wire signed [31:0] p2 = x_2  * b2;
    wire signed [31:0] p3 = y_1  * a1;
    wire signed [31:0] p4 = y_2  * a2;

    // addition may scale the output>32 bit so take 3 gap bit (geminis suggestion)
    // # Difference formula: y[n] = b0*x[n] + b1*x[n-1] + b2*x[n-2] - a1*y[n-1] - a2*y[n-2]
    // We already evaluated the negative 
    wire signed [34:0] accum = p0 + p1 + p2 + p3 + p4;

    // Shift right by 14 (remove Q2.14 scale) and take lower 16 bits
    wire signed [34:0] shifted_accum = accum >>> 14;

    always @(posedge clk) begin
        if (rst) begin
            // initialize evrything to 0 in beginning
            x_1 <= 0; 
            x_2 <= 0; 
            y_1 <= 0; 
            y_2 <= 0;
            y_out <= 0;
        
        // feedback from gemini
        // only process if a valid x_in is provided as input 
        end else if (data_valid) begin
            x_2 <= x_1;
            x_1 <= x_in;
            y_2 <= y_1;
            y_1 <= shifted_accum[15:0];
            y_out <= shifted_accum[15:0];
        end
    end
endmodule