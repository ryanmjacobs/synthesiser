module clkdiv_tb;

reg rst;
reg clk;
wire mclk;
wire lrclk;

initial begin
    $display("--- clk tb ---");
    $dumpfile("clkdiv.vcd");
    $dumpvars(0, rst, clk, mclk, lrclk);
end

clkdiv clkdiv(rst, clk, mclk, lrclk);

endmodule
