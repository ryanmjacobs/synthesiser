module clkdiv_tb;

reg rst = 0;
reg clk = 0;
wire mclk;
wire lrclk;
clkdiv clkdiv(rst, clk, mclk, lrclk);

initial begin
    $display("--- clk tb ---");
    $dumpfile("clkdiv.vcd");
    $dumpvars(0, rst, clk, mclk, lrclk);
end

initial begin
    #5 rst = 1;
    #5 rst = 0;
    #1000 $finish;
end
always #1 clk <= ~clk;

endmodule
