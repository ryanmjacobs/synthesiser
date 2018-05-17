module top(
	input clk,
    output reg [7:0] led,
    output mclk
);

initial led <= 8'b10101010;

endmodule
