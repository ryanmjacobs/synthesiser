// 100 MHz scale
`timescale 10ns/10ns
module top_tb();

reg rst = 0;
reg clk = 0;
wire [7:0] led;
wire mclk;
wire lrck;
wire sck;
wire sdout;

wire [7:0] phase;
wire [7:0] s;

top top(rst, clk, led, mclk, lrck, sck, sdout, phase, s, _);

initial begin
    $display("--- top tb ---");
    $dumpfile("top.vcd");
    $dumpvars(0, top_tb);
end

initial begin
    #2 rst = 1;
    #2 rst = 0;
    #8000 $finish;
end

// finish after our first lrck flip
//always @(posedge lrck) $finish;

// 100 Mhz clock
always #1 clk <= ~clk;

endmodule
