module register_file (
    input clk,
    input rst,

    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] write_data,
    input reg_write,

    output wire [31:0] read_data1,
    output wire [31:0] read_data2
);
    // using x seems convinient with my workflow
    reg [31:0] x [0:31];
    integer i;

    //safety: when x0 requested, should wlays be 0
    assign read_data1 =  (rs1==5'b0)? 32'b0:x[rs1];
    assign read_data2 = (rs2==5'b0)?32'b0:x[rs2];


    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                x[i] <= 32'b0;
        end else if (reg_write && (rd != 5'b0)) begin
            x[rd] <= write_data;
        end
    end
    
endmodule