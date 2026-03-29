`timescale 1ns / 1ps

module cnn_top(
    input clk,
    input rst,
    input start,

    input signed [15:0] in0, in1, in2, in3,

    output reg [3:0] class_out,
    output reg done
);

wire signed [31:0] r0, r1, r2, r3;
wire sa_done;

systolic_array sa (
    .clk(clk),
    .rst(rst),
    .start(start),
    .d0(in0), .d1(in1), .d2(in2), .d3(in3),
    .w0(16'd1), .w1(16'd1), .w2(16'd1), .w3(16'd1),
    .r0(r0), .r1(r1), .r2(r2), .r3(r3),
    .done(sa_done)
);

always @(posedge clk) begin
    if (rst) begin
        class_out <= 0;
        done <= 0;
    end
    else if (sa_done) begin
        // simple classifier
        if (r0 > r1 && r0 > r2 && r0 > r3)
            class_out <= 0;
        else if (r1 > r2 && r1 > r3)
            class_out <= 1;
        else if (r2 > r3)
            class_out <= 2;
        else
            class_out <= 3;

        done <= 1;
    end
end

endmodule