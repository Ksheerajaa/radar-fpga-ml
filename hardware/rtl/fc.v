module fc(
    input clk,
    input rst,
    input enable,

    input signed [15:0] input_vec [0:7],
    input signed [15:0] weight,

    output reg signed [15:0] out [0:3]
);

integer i,j;

always @(posedge clk) begin
    if(enable) begin

        for(i=0;i<4;i=i+1) begin
            out[i] = 0;

            for(j=0;j<8;j=j+1) begin
                out[i] = out[i] + input_vec[j] * weight;
            end
        end

    end
end

endmodule