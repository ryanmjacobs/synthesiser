// 100 MHz scale
`timescale 10ns/10ns
module top_tb();

reg rst = 0;
reg clk = 0;
wire [7:0] led;
wire mclk;
wire lrck;
wire sck;
top top(rst, clk, led, mclk, lrck, sck);

initial begin
    $display("--- top tb ---");
    $dumpfile("top.vcd");
    $dumpvars(0, led, mclk, lrck, sck);
end

initial #10000 $finish;

// 100 Mhz clock
always #1 clk <= ~clk;

endmodule
