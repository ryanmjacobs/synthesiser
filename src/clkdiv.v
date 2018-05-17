// 100 MHz scale
`timescale 10ns/10ns

module clkdiv(
    input rst,
    input clk,   //      Input Clock : 100 Mhz expected
    output mclk, //     Master Clock : 12.2880 Mhz
    output lrck  // Left-Right Clock : 48 Khz
);

reg out_clk [0:1];
reg [63:0] cnt [0:1];
reg [63:0] max [0:1];

wire mclk;  assign mclk  = out_clk[0];
wire lrclk; assign lrclk = out_clk[1];

// setup counter thresholds
initial begin
    max[0] <= 65/2;
    max[1] <= 100000000/2;
end

genvar i;
generate
    always @(posedge clk) begin
        // reset
        if (rst) begin
            for (i = 0; i < 2; i=i+1) begin
                cnt[i] <= 0;
                out_clk[i] <= 0;
            end
        end

        // increment counter for each clock
        /*
        for (i = 0; i < 2; i=i+1) begin
            if (cnt[i] >= max[i]) begin
                cnt[i] <= 0;
                out_clk[i] <= ~out_clk[i];
            end else begin
                cnt[i] <= cnt[i] + 1
            end
        end
        */
    end
endgenerate

endmodule
