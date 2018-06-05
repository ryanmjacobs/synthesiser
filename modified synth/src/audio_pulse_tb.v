// 100 MHz scale
`timescale 10ns/10ns

module audio_pulse_tb;

reg clk = 0;
wire pulse;

audio_pulse ap(clk, pulse);

initial begin
    $display("--- audio pulse tb ---");
    $dumpfile("audio_pulse.vcd");
    $dumpvars(0, audio_pulse_tb);
end

always #1 clk = ~clk;
initial #1e5 $finish;

endmodule
