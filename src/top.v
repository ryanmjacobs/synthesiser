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
reg [15:0] data = 24'b0000_0000_0000_0001;

clkdiv clkdiv(rst, clk, mclk, lrck);

always @(lrck)
    pos <= 0;

always @(posedge mclk) begin
    pos <= (pos + 1) % 16;
    sdout <= (data >> pos);
    sck <= 1;
end

always @(negedge mclk) begin
    sck <= 0;
end

endmodule
