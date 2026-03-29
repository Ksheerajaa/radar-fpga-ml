`timescale 1ns / 1ps

module systolic_array(
    input clk,
    input rst,
    input start,

    input signed [15:0] d0, d1, d2, d3,
    input signed [15:0] w0, w1, w2, w3,

    output reg signed [31:0] r0, r1, r2, r3,
    output reg done
);

reg signed [31:0] acc0, acc1, acc2, acc3;

always @(posedge clk) begin
    if (rst) begin
        acc0<=0; acc1<=0; acc2<=0; acc3<=0;
        done<=0;
    end
    else if(start) begin
        acc0 <= acc0 + d0*w0;
        acc1 <= acc1 + d1*w1;
        acc2 <= acc2 + d2*w2;
        acc3 <= acc3 + d3*w3;

        r0 <= acc0;
        r1 <= acc1;
        r2 <= acc2;
        r3 <= acc3;

        done <= 1;
    end
end

endmodule