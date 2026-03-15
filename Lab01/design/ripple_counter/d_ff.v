module d_ff (
    input clk, d, rst,
    output reg q
);

    always @(negedge clk or posedge rst) begin
        if (rst) begin
            q<=1'b0;
        end
       else begin
            q <= d; 
        end
    end

    
endmodule