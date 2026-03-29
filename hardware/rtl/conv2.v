module conv2(
    input clk, rst, start,
    input signed [63:0] in_flat,

    output reg signed [63:0] out_flat,
    output reg done
);

wire signed [15:0] x0 = in_flat[15:0];
wire signed [15:0] x1 = in_flat[31:16];
wire signed [15:0] x2 = in_flat[47:32];
wire signed [15:0] x3 = in_flat[63:48];

reg signed [31:0] acc0,acc1,acc2,acc3;

always @(posedge clk) begin
    if(rst) begin
        done<=0;
    end
    else if(start) begin

        acc0 = x0*2 + x1*3;
        acc1 = x1*4 + x2*2;
        acc2 = x2*3 + x3*5;
        acc3 = x0*1 + x3*2;

        out_flat <= {acc3[15:0],acc2[15:0],acc1[15:0],acc0[15:0]};
        done<=1;
    end
end

endmodule