module top(
	input clk,
    output reg [7:0] led,
    output mclk
);

reg mclk = 0;
reg lclk = 0;
reg [63:0] mclk_cnt = 0;
reg [63:0] lclk_cnt = 0;

// initial state
initial begin
    led <= 8'b10101010;
end

// master clock
// 2 × 48 KHz × 16 = 1.536 MHz
always @(posedge clk) begin
    mclk_cnt = mclk_cnt + 1;
    lclk_cnt = lclk_cnt + 1;
    
    if (mclk_cnt >= 65/2) begin
        mclk_cnt = 0;
        mclk = ~mclk;
    end
    
    if (lclk_cnt >= 100000000/2) begin
        lclk_cnt = 0;
        lclk = ~lclk;
    end
end

always @(posedge lclk) begin
    led <= ~led;
end

endmodule
