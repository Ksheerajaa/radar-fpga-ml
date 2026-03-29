module mac_unit(
    input clk,
    input rst,
    input enable,

    input signed [15:0] a,
    input signed [15:0] b,

    input signed [31:0] acc_in,
    output reg signed [31:0] acc_out
);

always @(posedge clk) begin
    if(rst)
        acc_out <= 0;
    else if(enable)
        acc_out <= acc_in + (a * b);
end

endmodule