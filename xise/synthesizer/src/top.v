module top(
    input rst,
	input clk,
    output reg [7:0] led
);

initial led <= 8'b10101010;

endmodule
