// 100 MHz scale
`timescale 10ns/10ns
module top_tb(
    output reg clk
);

initial begin
    $display("--- top tb ---");
    $dumpfile("top.vcd");
    $dumpvars(0, clk);
end

// 100 Mhz clock
always #1 clk <= ~clk;

endmodule
