// Module for generating sawtooth and triangle waves
module tri_saw_gen(freq, clk, sig_saw, sig_tri);
    input [11:0] freq;
    input clk;  // 1MHz clock
    output reg [15:0] sig_saw;
    output reg [15:0] sig_tri;
    
    reg [15:0] sig_temp;
    reg [31:0] cycles;
    reg [31:0] sigPeriod;
    reg [15:0] amplitude;
    reg [15:0] X;
    reg [35:0] AmulC;
    
    initial begin
        sig_saw <= 16'b0;
        sig_tri <= 16'b0;
        
        sig_temp <= 16'b0;
        cycles <= 0;
        sigPeriod <= 1000000 / 440;
        amplitude <= 16'b0000111111111111;
    end
    
    // Sawtooth wave equation:
    // sig_saw = ((amplitude * cycles) / sigPeriod) - X
    // where X = 0 if the cycles is less than half the
    // period and X = amplitude otherwise
    
    // Triangle wave derived from shifting and scaling part of sawtooth
    
    always @(posedge clk)
    begin
        // Reset the cycle count after every period
        if (cycles >= sigPeriod) begin
            cycles = 0;
        end
        
        if ((cycles << 1) < sigPeriod) begin
            X = 0;
        end
        else begin
            X = amplitude;
        end
        
        // Multiply the amplitude and cycle count into a larger
        // temporary register
        AmulC = amplitude * cycles;
        sig_temp = (AmulC / sigPeriod) - X;
        sig_saw = sig_temp;
        
        // Convert sawtooth wave into triangle wave
        if (sig_temp[15] == 1) begin
            sig_temp = ~sig_temp + 1;
        end
        sig_temp = sig_temp - (amplitude >> 2);
        sig_tri = sig_temp << 2;
        
        cycles = cycles + 1;
        sigPeriod <= 1000000 / freq;
    end
endmodule
