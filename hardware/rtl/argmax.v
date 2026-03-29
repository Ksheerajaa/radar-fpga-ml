module argmax #(
    parameter SIZE = 4,
    parameter DATA_WIDTH = 16
)(
    input signed [DATA_WIDTH-1:0] in [0:SIZE-1],
    output reg [1:0] max_index
);

integer i;

reg signed [DATA_WIDTH-1:0] max_val;

always @(*) begin
    max_val = in[0];
    max_index = 0;

    for (i = 1; i < SIZE; i = i + 1) begin
        if (in[i] > max_val) begin
            max_val = in[i];
            max_index = i;
        end
    end
end

endmodule