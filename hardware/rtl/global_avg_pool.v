module global_avg_pool #(
    parameter SIZE = 10,
    parameter DATA_WIDTH = 16
)(
    input signed [DATA_WIDTH-1:0] in [0:SIZE-1],
    output reg signed [DATA_WIDTH-1:0] out
);

integer i;

reg signed [31:0] sum;

always @(*) begin
    sum = 0;
    for (i = 0; i < SIZE; i = i + 1)
        sum = sum + in[i];

    out = sum / SIZE;
end

endmodule