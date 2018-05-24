module top(
    input rst,
	input clk,
    output reg [7:0] led,

    output i2s_mclk,
    output reg i2s_lrck,
    output i2s_sck,
    output reg i2s_sdin,
    output i2s_gnd,
    output i2s_vcc,

    output [7:0] phase,
    output [7:0] s
);

// i2s power supply
assign i2s_gnd = 0;
assign i2s_vcc = 1;

initial led <= 8'b10101010;

//reg i2s_lrck;
reg [3:0]  pos = 0;
reg [15:0] data = 16'b0001_1000;

clkdiv clkdiv(rst, clk, i2s_mclk);

// sine wave table
reg [7:0] phase = 0;
reg	[6:0] sine [0:255];
assign s = sine[phase];
initial $readmemh("sine.hex", sine);

// initial states
initial begin
    i2s_lrck <= 0;
    //i2s_sck  <= 1;
    i2s_sdin <= 0;
end

// reset position when we switch from
// Left to Right (or vice versa)
always @(i2s_lrck) begin
    phase <= phase + 1;
  //data <= sine[phase];
    data <= 16'b1111_0000_0000_1100;
end

assign i2s_sck = i2s_mclk;

always @(posedge i2s_mclk) begin
    //i2s_sck <= 0;
    pos <= pos + 1;
    i2s_sdin <= (data >> ~pos);

    if (pos == 15) begin
        pos <= 0;
        i2s_lrck <= ~i2s_lrck;
    end
end

//always @(negedge i2s_mclk)
//    i2s_sck <= 1;

endmodule
