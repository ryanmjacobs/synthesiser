module synthesizer(
    clk, sw, btnl, btnd, btnr, btnu, JA, seg, an,

    // Ram Access passthrough
    MemDB, MemAdr, RamAdv, RamClk, RamCS, MemOE, MemWR, RamLB, RamUB
);
    input clk;          // 100MHz clock
    input [7:0] sw;
    input btnl;         // left button, "record"
    input btnd;         // bottom button, "play"
    input btnr;         // right button, "cycle track"
    input btnu;         // top button, "play track"
    inout [3:0] JA;     // pmodi2s module
    output [7:0] seg;   // 7 seg display
    output [3:0] an;    // panel selector
    
    wire [15:0] sig_square; // Square wave
    wire [15:0] sig_saw;    // Sawtooth wave
    wire [15:0] sig_tri;    // Triangle wave
    wire [15:0] sig_sine;   // Sine wave
    wire [15:0] sig;        // Total audio output signal
    wire [11:0] freq;       // Current frequency to 
    wire play, cycle, playtrack, record;
    wire [2:0] note;
    wire [1:0] octave;
    wire accident;
    wire [1:0] tracks_playing;
	wire current_track;
    wire [15:0] sig_mem;

    // RAM Access passthrough
    inout  [15:0] MemDB;
    output [22:0] MemAdr;
    output RamAdv, RamClk, RamCS, MemOE, MemWR, RamLB, RamUB;

    // interface
    sw_interface sw_interface(clk, sw[5:0], freq, note, octave, accident);
    debounce play_button(clk, btnd, play);
    debounce cycle_button(clk, btnr, cycle);
    debounce playtr_button(clk, btnu, playtrack);
    debounce record_button(clk, btnl, record);

    display display (clk, note, tracks_playing, current_track, octave, accident, an, seg);
    osc_square sqwave (freq, JA[2], sig_square);
    osc_tri_saw sawtriwave (freq, JA[2], sig_saw, sig_tri);
    osc_sine sinesc_ (freq, JA[2], sig_sine);
    sig_adder sigadd_ (clk, sw[7:6], play, sig_square, sig_saw, sig_tri, sig_sine, sig_mem, sig);
	 
    track_controller track_controller(clk, cycle, playtrack, current_track, tracks_playing);
    async_controller async_controller_(
        .clk(clk),
        .WR(record),
        .data_write(sig),
        
        .track_writing(current_track),
        .tracks_playing(tracks_playing),

        .MemDB(MemDB),
        .MemAdr(MemAdr),
        .RamAdv(RamAdv),
        .RamClk(RamClk),
        .RamCS(RamCS),
        .MemOE(MemOE),
        .MemWR(MemWR),
        .RamLB(RamLB),
        .RamUB(RamUB),
        .data_read(sig_mem)
    );

    pmod_out out_ (sig, clk, JA[0], JA[1], JA[2], JA[3]);
endmodule
