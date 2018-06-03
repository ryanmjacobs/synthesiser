// 100 MHz scale
`timescale 10ns/10ns

module clkdiv(
    input rst,
    input clk,       //      Input Clock : 100 Mhz expected
    output reg mclk, //     Master Clock : 12.5 Mhz
    output reg lrck  // Left-Right Clock : 48 Khz
);

// counters
reg [63:0] mclk_cnt;
reg [63:0] lrck_cnt;

// counter thresholds
parameter mclk_max = 4;
parameter lrck_max = 1024;

// mclk
always @(posedge clk) begin
    // reset
    if (rst) begin
        mclk <= 0;
        mclk_cnt <= 0;
    end else begin
        // increment counter
        if (mclk_cnt < mclk_max) begin
            mclk_cnt <= mclk_cnt + 1;
        end else begin
            mclk_cnt <= 0;

            // create a pulse
            if (mclk == 0)
                mclk <= 1;
            else
                mclk <= 0;
        end
    end
end

// lrck
always @(posedge clk) begin
    // reset
    if (rst) begin
        lrck <= 0;
        lrck_cnt <= 0;
    end else begin
        // increment counter on mclk
        if (mclk) begin
            if (lrck_cnt < lrck_max) begin
                lrck_cnt <= lrck_cnt + 1;
            end else begin
                lrck_cnt <= 0;

                // create a pulse
                if (lrck == 0)
                    lrck <= 1;
                else
                    lrck <= 0;
            end
        end
    end
end

endmodule
