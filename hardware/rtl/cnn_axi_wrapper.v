module cnn_axi_wrapper_v1_0 #
(
    parameter integer C_S_AXI_DATA_WIDTH = 32,
    parameter integer C_S_AXI_ADDR_WIDTH = 4
)
(
    input wire S_AXI_ACLK,
    input wire S_AXI_ARESETN,

    input wire [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_AWADDR,
    input wire S_AXI_AWVALID,
    output reg S_AXI_AWREADY,

    input wire [C_S_AXI_DATA_WIDTH-1:0] S_AXI_WDATA,
    input wire S_AXI_WVALID,
    output reg S_AXI_WREADY,

    output reg [1:0] S_AXI_BRESP,
    output reg S_AXI_BVALID,
    input wire S_AXI_BREADY,

    input wire [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_ARADDR,
    input wire S_AXI_ARVALID,
    output reg S_AXI_ARREADY,

    output reg [C_S_AXI_DATA_WIDTH-1:0] S_AXI_RDATA,
    output reg [1:0] S_AXI_RRESP,
    output reg S_AXI_RVALID,
    input wire S_AXI_RREADY
);

reg [31:0] reg0;
reg [31:0] reg1;

wire done;
wire [31:0] result;

cnn_top uut (
    .clk(S_AXI_ACLK),
    .rst(~S_AXI_ARESETN),
    .start(reg0[0]),
    .data_in(reg1),
    .result(result),
    .done(done)
);

cnn_top cnn_inst (
    .clk(S_AXI_ACLK),
    .rst(~S_AXI_ARESETN),
    .start(start_reg),
    .in0(data_reg[15:0]),
    .in1(data_reg[31:16]),
    .in2(16'd0),
    .in3(16'd0),
    .class_out(class_out),
    .done(done)
);

// WRITE RESPONSE CHANNEL
assign S_AXI_BRESP = 2'b00;
assign S_AXI_BVALID = S_AXI_AWVALID & S_AXI_WVALID;

// READ RESPONSE
assign S_AXI_RRESP = 2'b00;
assign S_AXI_RVALID = S_AXI_ARVALID;

// READY SIGNALS
assign S_AXI_AWREADY = 1;
assign S_AXI_WREADY  = 1;
assign S_AXI_ARREADY = 1;

// WRITE
always @(posedge S_AXI_ACLK) begin
    if (!S_AXI_ARESETN) begin
        S_AXI_AWREADY <= 0;
        S_AXI_WREADY <= 0;
        S_AXI_BVALID <= 0;
    end else begin
        S_AXI_AWREADY <= S_AXI_AWVALID;
        S_AXI_WREADY <= S_AXI_WVALID;

        if (S_AXI_WVALID) begin
            case (S_AXI_AWADDR)
                4'h0: reg0 <= S_AXI_WDATA;
                4'h4: reg1 <= S_AXI_WDATA;
            endcase
            S_AXI_BVALID <= 1;
            S_AXI_BRESP <= 2'b00;
        end

        if (S_AXI_BREADY)
            S_AXI_BVALID <= 0;
    end
end

// READ
always @(posedge S_AXI_ACLK) begin
    if (!S_AXI_ARESETN) begin
        S_AXI_ARREADY <= 0;
        S_AXI_RVALID <= 0;
    end else begin
        S_AXI_ARREADY <= S_AXI_ARVALID;

        if (S_AXI_ARVALID) begin
            case (S_AXI_ARADDR)
                4'h0: S_AXI_RDATA <= reg0;
                4'h4: S_AXI_RDATA <= reg1;
                4'h8: S_AXI_RDATA <= result;
                4'hC: S_AXI_RDATA <= {31'b0, done};
            endcase

            S_AXI_RVALID <= 1;
            S_AXI_RRESP <= 2'b00;
        end

        if (S_AXI_RREADY)
            S_AXI_RVALID <= 0;
    end
end

endmodule