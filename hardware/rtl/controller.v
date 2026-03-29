module controller(
    input clk,
    input rst,
    input start,

    input conv1_done,
    input conv2_done,
    input fc_done,

    output reg conv1_start,
    output reg conv2_start,
    output reg fc_start,
    output reg done
);

reg [2:0] state;

localparam IDLE  = 0;
localparam CONV1 = 1;
localparam CONV2 = 2;
localparam FC    = 3;
localparam DONE  = 4;

always @(posedge clk) begin
    if (rst) begin
        state <= IDLE;
        done <= 0;
    end else begin
        case(state)
            IDLE:  if(start) state <= CONV1;

            CONV1: if(conv1_done) state <= CONV2;

            CONV2: if(conv2_done) state <= FC;

            FC:    if(fc_done) state <= DONE;

            DONE:  done <= 1;
        endcase
    end
end

always @(*) begin
    conv1_start = (state == CONV1);
    conv2_start = (state == CONV2);
    fc_start    = (state == FC);
end

endmodule