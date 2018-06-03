module clkdiv_tb;

reg rst = 0;
reg clk = 0;
wire mclk;
wire lrck;
clkdiv clkdiv(rst, clk, mclk, lrck);

integer mclk_cnt = 0;

initial begin
    $display("--- clk tb ---");
    $dumpfile("clkdiv.vcd");
    $dumpvars(0, rst, clk, mclk, lrck, mclk_cnt);
end

initial begin
    #5 rst = 1;
    #5 rst = 0;
    #5000 $finish;
end
always #1 clk <= ~clk;

always @(posedge clk) begin
    if (mclk)
        mclk_cnt <= mclk_cnt + 1;
end

endmodule
