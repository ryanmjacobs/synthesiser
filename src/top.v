module top(
    input rst,
	input clk,
    output reg [7:0] led,

    output mclk,
    output lrck,
    output reg sck,
    output reg sdout,

    output [7:0] phase,
    output [7:0] s
);

initial led <= 8'b10101010;

reg lrck;
reg [2:0]  pos = 0;
reg [7:0] data = 24'b0001_1000;

clkdiv clkdiv(rst, clk, mclk, _);

// sine wave table
reg [7:0] phase = 0;
reg	[6:0] sine [0:255];
assign s = sine[phase];
initial $readmemh("sine.hex", sine);

// initial states
initial begin
    lrck  <= 0;
    sck   <= 1;
    sdout <= 0;
end

// reset position when we switch from
// Left to Right (or vice versa)
always @(lrck) begin
    phase <= phase + 1;
    sdout <= sine[phase];
    pos <= 0;
end

always @(posedge mclk) begin
    sck <= 0;
    pos <= pos + 1;
    sdout <= (data >> pos);

    if (pos == 7)
        lrck <= ~lrck;
end

always @(negedge mclk)
    sck <= 1;

endmodule
