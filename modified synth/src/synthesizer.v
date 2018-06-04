`timescale 1ns / 1ps

module synthesizer(clk, sw, btns, JA, seg, an);
    input clk;          // 500MHz built-in clock
    input [7:0] sw;     // Switches for choosing which types of waveforms
                        // to include in the output audio signal
    input btns;
    inout [3:0] JA;     // Connectors for PmodI2S stereo audio output
    output [6:0] seg;   // 7-segment display onboard Nexys 3 board
    output [3:0] an;    // Anode for 7-segment display
    
    wire [15:0] sig_square; // Square wave
    wire [15:0] sig_saw;    // Sawtooth wave
    wire [15:0] sig_tri;    // Triangle wave
    wire [15:0] sig_sine;   // Sine wave
    wire [15:0] sig;        // Total audio output signal
    wire [11:0] freq;       // Current frequency to 
    wire play;
    
    // Pmod keypad input module which allows user to choose which note
    // (frequency) to play

    sw_interface sw_interface(clk, sw[5:0], freq);
    debounce play_button(clk, btns, play);
    display display (freq, seg, an);
    osc_square sqwave (freq, JA[2], sig_square);
    osc_tri_saw sawtriwave (freq, JA[2], sig_saw, sig_tri);
    osc_sine sinesc_ (freq, JA[2], sig_sine);
    sig_adder sigadd_ (clk, sw[7:6], play, sig_square, sig_saw, sig_tri, sig_sine, sig);
    pmod_out out_ (sig, clk, JA[0], JA[1], JA[2], JA[3]);
endmodule
