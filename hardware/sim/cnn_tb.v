`timescale 1ns / 1ps

module tb_cnn_top;

    reg clk;
    reg rst;
    reg start;

    wire done;
    wire [1:0] class_out;

    cnn_top uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .data_in(data_in),
        .done(done),
        .class_out(class_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        start = 0;

        #20;
        rst = 0;

        #20;
        start = 1;

        #10;
        start = 0;

        #200;
        $finish;
    end

endmodule