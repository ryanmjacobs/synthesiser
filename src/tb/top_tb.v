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
top top(rst, clk, led, mclk, lrck, sck, sdout);

initial begin
    $display("--- top tb ---");
    $dumpfile("top.vcd");
    $dumpvars(0, led, mclk, lrck, sck, sdout);
end

initial begin
    #10 rst = 1;
    #5 rst = 0;
    #10000 $finish;
end

// finish after our first lrck flip
//always @(negedge lrck) $finish;

// 100 Mhz clock
always #1 clk <= ~clk;

endmodule
