// Module for generating a sine wave
module sine_gen(freq, clk, sin);
    input [11:0] freq;
    input clk;          
    output reg [15:0] sin;  // Signal value
    
    integer sin_curr;
    integer cos_curr;
    integer sin_last;
    integer cos_last;
    integer denom;
    
    initial begin
        sin_last <= 0;
        cos_last <= 32'b00011111111111110000000000000000;
        denom = 159154 / 440;
    end
    
    // PLL used to generate sin waves

    always @(posedge clk)
    begin
        sin_curr = (cos_last / denom);
        sin_curr = sin_last + sin_curr;
        cos_curr = (sin_last / denom);
        cos_curr = cos_last - cos_curr;
        
        sin = sin_curr[31:16];
        
        // Reinitialize values at the beginning of every period
        if (sin_curr[31] == 0 && sin_last[31] == 1) begin
            sin_last = 0;
            cos_last = 32'b00011111111111110000000000000000;
            denom = 159154 / freq;
        end
        // Update sin(t-1) and cos(t-1) before subsequent sine wave calculation
        else begin
            sin_last = sin_curr;
            cos_last = cos_curr;
        end
    end
    
endmodule
