module fc_layer(
    input clk,
    input rst,
    input start,

    input signed [15:0] in0, in1, in2, in3,

    output signed [31:0] out0, out1, out2, out3,
    output done
);

wire signed [15:0] w0=16'd2, w1=16'd3, w2=16'd4, w3=16'd5;

systolic_array sa (
    .clk(clk),
    .rst(rst),
    .start(start),

    .d0(in0), .d1(in1), .d2(in2), .d3(in3),
    .w0(w0), .w1(w1), .w2(w2), .w3(w3),

    .r0(out0), .r1(out1), .r2(out2), .r3(out3),
    .done(done)
);

endmodule