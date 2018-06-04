`timescale 1ns / 1ps
module sw_interface(clk, sw, freq);
    input clk;
    input [5:0] sw;
    output reg [11:0] freq;

    integer C4 = 261;
    integer D4 = 293;
    integer E4 = 330;
    integer F4 = 349;
    integer G4 = 392;
    integer A4 = 440;
    integer B4 = 494;
    integer Cs4 = 277;
    integer Ds4 = 311;
    integer Fs4 = 330;
    integer Gs4 = 370;
    integer As4 = 466;
    
    initial begin
        freq <= A4; 
    end

    always @(posedge clk)
    begin
        // Octave shift sw[5:4]: 
        // 0: octave 4
        // 1: octave 5
        // 2: octave 6
        // 3: octave 3
        // Note Selection sw[2:0]: picks note, going up from C to B
        // Accidental shifter sw[3]: shifts up half step if it has a "sharp" note
        case (sw)
            // octave 4
            6'b000000 : freq <= C4; // C4
            6'b000001 : freq <= D4; // D4
            6'b000010 : freq <= E4; // E4
            6'b000011 : freq <= F4; // F4
            6'b000100 : freq <= G4; // G4
            6'b000101 :freq <= A4; // A4
            6'b000110 :freq <= B4; // B4
            // accidentals, octave 4
            6'b001000 : freq <= Cs4; // C#
            6'b001001 : freq <= Ds4; // D#
            6'b001010 : freq <= E4; // E
            6'b001011 : freq <= Fs4; // F#
            6'b001100 : freq <= Gs4; // G#
            6'b001101 :freq <= As4; // A#
            6'b001110 :freq <= B4; // B

            // octave 5
            6'b010000 : freq <= (C4 << 1); // C4
            6'b010001 : freq <= (D4 << 1); // D4
            6'b010010 : freq <= (E4 << 1); // E4
            6'b010011 : freq <= (F4 << 1); // F4
            6'b010100 : freq <= (G4 << 1); // G4
            6'b010101 :freq <= (A4 << 1); // A4
            6'b010110 :freq <= (B4 << 1); // B4
            // accidentals, octave 5
            6'b011000 : freq <= (Cs4 << 1); // C#
            6'b011001 : freq <= (Ds4 << 1); // D#
            6'b011010 : freq <= (E4 << 1); // E
            6'b011011 : freq <= (Fs4 << 1); // F#
            6'b011100 : freq <= (Gs4 << 1); // G#
            6'b011101 :freq <= (As4 << 1); // A#
            6'b011110 :freq <= (B4 << 1); // B

            // octave 6
            6'b100000 : freq <= (C4 << 2); // C4
            6'b100001 : freq <= (D4 << 2); // D4
            6'b100010 : freq <= (E4 << 2); // E4
            6'b100011 : freq <= (F4 << 2); // F4
            6'b100100 : freq <= (G4 << 2); // G4
            6'b100101 :freq <= (A4 << 2); // A4
            6'b100110 :freq <= (B4 << 2); // B4
            // accidentals, octave 6
            6'b101000 : freq <= (Cs4 << 2); // C#
            6'b101001 : freq <= (Ds4 << 2); // D#
            6'b101010 : freq <= (E4 << 2); // E
            6'b101011 : freq <= (Fs4 << 2); // F#
            6'b101100 : freq <= (Gs4 << 2); // G#
            6'b101101 :freq <= (As4 << 2); // A#
            6'b101110 :freq <= (B4 << 2); // B

            // octave 3
            6'b110000 : freq <= (C4 >> 1); // C
            6'b110001 : freq <= (D4 >> 1); // D
            6'b110010 : freq <= (E4 >> 1); // E
            6'b110011 : freq <= (F4 >> 1); // F
            6'b110100 : freq <= (G4 >> 1); // G
            6'b110101 :freq <= (A4 >> 1); // A
            6'b110110 :freq <= (B4 >> 1); // B
            // accidentals, octave 3
            6'b111000 : freq <= (Cs4 >> 1); // C#
            6'b111001 : freq <= (Ds4 >> 1); // D#
            6'b111010 : freq <= (E4 >> 1); // E
            6'b111011 : freq <= (Fs4 >> 1); // F#
            6'b111100 : freq <= (Gs4 >> 1); // G#
            6'b111101 :freq <= (As4 >> 1); // A#
            6'b111110 :freq <= (B4 >> 1); // B
            default : freq <= 11'd440; // A4
        endcase
    end
endmodule

