module clkdiv_tb;

reg rst = 0;
reg clk = 0;
wire mclk;
wire lrck;
clkdiv clkdiv(rst, clk, mclk, lrck);

initial begin
    $display("--- clk tb ---");
    $dumpfile("clkdiv.vcd");
    $dumpvars(0, rst, clk, mclk, lrck);
end

initial begin
    #5 rst = 1;
    #5 rst = 0;
    #5000 $finish;
end
always #1 clk <= ~clk;

endmodule
