module weights_mem(
    input clk,
    input [9:0] addr,
    output reg signed [15:0] data
);

reg signed [15:0] mem [0:1023];  // adjust size if needed

initial begin
    $readmemh("quantized_weights.mem", mem);
end

always @(posedge clk) begin
    data <= mem[addr];
end

endmodule