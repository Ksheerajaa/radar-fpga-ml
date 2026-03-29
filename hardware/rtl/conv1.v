module conv1(
    input clk, rst, start,
    input signed [191:0] in_flat,

    output reg signed [63:0] out_flat,
    output reg done
);

wire signed [15:0] x [0:11];

genvar i;
generate
for(i=0;i<12;i=i+1) begin
    assign x[i] = in_flat[i*16 +: 16];
end
endgenerate

// Weight memory
reg [9:0] addr;
wire signed [15:0] w;

weights_mem wm(.clk(clk), .addr(addr), .data(w));

integer k;
reg signed [31:0] acc[0:3];

always @(posedge clk) begin
    if(rst) begin
        addr<=0;
        done<=0;
    end
    else if(start) begin

        for(k=0;k<4;k=k+1) acc[k]=0;

        for(k=0;k<12;k=k+1) begin
            addr <= k;
            acc[0] = acc[0] + x[k]*w;
            acc[1] = acc[1] + x[k]*w;
            acc[2] = acc[2] + x[k]*w;
            acc[3] = acc[3] + x[k]*w;
        end

        out_flat <= {acc[3][15:0], acc[2][15:0], acc[1][15:0], acc[0][15:0]};
        done <= 1;
    end
end

endmodule