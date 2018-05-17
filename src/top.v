module top(
    input rst,
	input clk,
  //output reg [7:0] led,

    output mclk,
    output lrck,
    output reg sck
);

//initial led <= 8'b10101010;

// produce dummy data
initial sck <= 1;
clkdiv clkdiv(rst, clk, mclk, lrck);

endmodule
