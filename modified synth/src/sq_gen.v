// Module for generating a square wave
module sq_gen(freq, clk, sig);
    input [11:0] freq;
    input clk;          // 1MHz clock
    output reg [15:0] sig;  // Square wave signal
    
    reg [31:0] cycles;      // Time in clock cycles
    reg [31:0] half_period;
    
    initial begin
        // Initialize signal at default positive maginitude
        sig <= 16'b0000011111111111;
        cycles <= 0;
        // Initialize the half-period of the waveform to correspond to a
        // frequency of 440Hz
        half_period <= 1000000 / (440 * 2);
    end
    
    always @(posedge clk)
    begin
        // Flip the signal at every half-period
        if (cycles >= half_period) begin
            sig <= ~sig;
            cycles <= 0;
        end
        else begin
            cycles <= cycles + 1;
        end
        half_period = 1000000 / (freq * 2);
    end
endmodule
