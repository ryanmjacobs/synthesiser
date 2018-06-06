// Module which sends the total calculated output signal to the PmodI2S
// stereo audio output device
module pmod_out(sig, clk, MCLK, LRCLK, SCLK, sig_out);
    input [15:0] sig;
    input clk;      // 100MHz clock
    output reg MCLK;    // Master clock to send to PmodI2S to maintain
                    // synchronization
    output reg LRCLK;   // Left-right clock stereo audio output
    output reg SCLK;    // Clock for transmitting induvidual signal bits
                    // to PmodI2S
    output reg sig_out;    // Current signal bit to transmit

    reg [15:0] sig_temp;
    reg [4:0] MCLK_cnt;
    reg [5:0] LRCLK_cnt;
    reg [10:0] SCLK_cnt;

    initial begin
        MCLK <= 0;
        LRCLK <= 0;
        SCLK <= 0;
    
        sig_temp <= sig;
        MCLK_cnt <= 0;
        LRCLK_cnt <= 0;
        SCLK_cnt <= 0;
    end

    always @(posedge clk)
    begin
        // 2000kHz
        if (MCLK_cnt == 25) begin
            MCLK = ~MCLK;
            MCLK_cnt = 0;
        end
        // 1000kHz
        if (SCLK_cnt == 50) begin
            SCLK = ~SCLK;
            SCLK_cnt = 0;
            // Transmit the signal bit-by-bit at every negative edge of
            // the SCLK
            if (SCLK == 0) begin
                sig_out = sig_temp[15];
                sig_temp = sig_temp << 1;
            end
        end
        // 31.25kHz
        if (LRCLK_cnt == 1600) begin
            LRCLK = ~LRCLK;
            LRCLK_cnt = 0;
            // Reset sig_temp to the current signal when switching sides
            // of stereo output to transmit
            sig_temp = sig;
        end
        
        MCLK_cnt = MCLK_cnt + 1;
        LRCLK_cnt = LRCLK_cnt + 1;
        SCLK_cnt = SCLK_cnt + 1;
    end
    
endmodule

