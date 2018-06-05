module synthesizer(clk, sw, btns, JA, seg, an);
    input clk;          // 100MHz clock
    input [7:0] sw;
    input btns;         // middle button, "play"
    inout [3:0] JA;     // pmodi2s module
    output [6:0] seg;   // 7 seg display
    output [3:0] an;    // panel selector
    
    wire [15:0] sig_square; // Square wave
    wire [15:0] sig_saw;    // Sawtooth wave
    wire [15:0] sig_tri;    // Triangle wave
    wire [15:0] sig_sine;   // Sine wave
    wire [15:0] sig;        // Total audio output signal
    wire [11:0] freq;       // Current frequency to 
    wire play;

    sw_interface sw_interface(clk, sw[5:0], freq);
    debounce play_button(clk, btns, play);
    display display (freq, an, seg);
    osc_square sqwave (freq, JA[2], sig_square);
    osc_tri_saw sawtriwave (freq, JA[2], sig_saw, sig_tri);
    osc_sine sinesc_ (freq, JA[2], sig_sine);
    sig_adder sigadd_ (clk, sw[7:6], play, sig_square, sig_saw, sig_tri, sig_sine, sig);

    wire [15:0] sig_asd;
    async_controller async_controller_(
        .clk(clk),
        .WR(btns),
        .data_write(sig),

        .MemDB(MemDB),
        .MemAdr(MemAdr),
        .RamAdv(RamAdv),
        .RamClk(RamClk),
        .RamCS(RamCS),
        .MemOE(MemOE),
        .MemWR(MemWR),
        .RamLB(RamLB),
        .RamUB(RamUB),
        .data_read(sig_asd)
    );

    pmod_out out_ (sig_asd, clk, JA[0], JA[1], JA[2], JA[3]);
endmodule
