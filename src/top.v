module top(
    input rst,
	input clk,
    output reg [7:0] led,

    output mclk,
    output lrck,
    output reg sck,
    output reg sdout
);

initial led <= 8'b10101010;

reg [4:0]  pos = 0;
reg [23:0] data = 24'b1001_0000_1001_0000_1001_0000;

clkdiv clkdiv(rst, clk, mclk, lrck);

always @(posedge mclk) begin
    pos <= (pos + 1) % 24;
    sdout <= (~data >> pos) & 1;
    sck <= 1;
end

always @(negedge mclk) begin
    sck <= 0;
end

endmodule
