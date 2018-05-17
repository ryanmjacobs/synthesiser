module top(
	input clk,
    output reg [7:0] led,
    output mclk
);

// blink LEDs
initial led <= 8'b10101010;
always @(posedge lclk) led <= ~led;

endmodule
