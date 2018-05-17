// 100 MHz scale
`timescale 10ns/10ns

module clkdiv(
    input clk,        //      Input Clock : 100 Mhz expected
    output reg mclk,  //     Master Clock : 12.2880 Mhz
    output reg lrck   // Left-Right Clock : 48 Khz
);

reg mclk = 0;
reg lclk = 0;
reg [63:0] mclk_cnt = 0;
reg [63:0] lclk_cnt = 0;

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

endmodule
