`timescale 1ns / 1ps

// Pmod keypad input module which allows user to choose which note
// (frequency) to play
module sw_interface(clk, sw, freq);
    input clk;
    input [5:0] sw;
    output [11:0] freq;
    
    reg [3:0] Col;
    reg [11:0] freq;

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
        freq <= 440;    // Default note A
    end

    always @(posedge clk)
    begin
        // If sw[3] is set, sw[2:0] moves up half a step (unless E or B)
        /*
        if (~sw[3]) begin
            case (sw)
                0 : freq <= 11'd261; // C
                1 : freq <= 11'd293; // D
                2 : freq <= 11'd330; // E
                3 : freq <= 11'd349; // F
                4 : freq <= 11'd392; // G
                5 :freq <= 11'd440; // A
                6 :freq <= 11'd494; // B
                default : freq <= 11'd440;
            endcase
        end else begin
            case (sw)
                0 : freq <= 11'd277; // C#
                1 : freq <= 11'd311; // D#
                2 : freq <= 11'd330; // E
                3 : freq <= 11'd370; // F#
                4 : freq <= 11'd415; // G#
                5 :freq <= 11'd466; // A#
                6 :freq <= 11'd494; // B
                default : freq <= 11'd466;
            endcase
        end */
        case (sw)
            /*
            // default, octave 4
            6'b000000 : freq <= 11'd261; // C4
            6'b000001 : freq <= 11'd293; // D4
            6'b000010 : freq <= 11'd330; // E4
            6'b000011 : freq <= 11'd349; // F4
            6'b000100 : freq <= 11'd392; // G4
            6'b000101 :freq <= 11'd440; // A4
            6'b000110 :freq <= 11'd494; // B4
            // accidentals, octave 4
            6'b001000 : freq <= 11'd277; // C#
            6'b001001 : freq <= 11'd311; // D#
            6'b001010 : freq <= 11'd330; // E
            6'b001011 : freq <= 11'd370; // F#
            6'b001100 : freq <= 11'd415; // G#
            6'b001101 :freq <= 11'd466; // A#
            6'b001110 :freq <= 11'd494; // B
            */

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
            6'b000000 : freq <= (C4 << 1); // C4
            6'b000001 : freq <= (D4 << 1); // D4
            6'b000010 : freq <= (E4 << 1); // E4
            6'b000011 : freq <= (F4 << 1); // F4
            6'b000100 : freq <= (G4 << 1); // G4
            6'b000101 :freq <= (A4 << 1); // A4
            6'b000110 :freq <= (B4 << 1); // B4
            // accidentals, octave 5
            6'b001000 : freq <= (Cs4 << 1); // C#
            6'b001001 : freq <= (Ds4 << 1); // D#
            6'b001010 : freq <= (E4 << 1); // E
            6'b001011 : freq <= (Fs4 << 1); // F#
            6'b001100 : freq <= (Gs4 << 1); // G#
            6'b001101 :freq <= (As4 << 1); // A#
            6'b001110 :freq <= (B4 << 1); // B

            // octave 6
            6'b000000 : freq <= (C4 << 2); // C4
            6'b000001 : freq <= (D4 << 2); // D4
            6'b000010 : freq <= (E4 << 2); // E4
            6'b000011 : freq <= (F4 << 2); // F4
            6'b000100 : freq <= (G4 << 2); // G4
            6'b000101 :freq <= (A4 << 2); // A4
            6'b000110 :freq <= (B4 << 2); // B4
            // accidentals, octave 6
            6'b001000 : freq <= (Cs4 << 2); // C#
            6'b001001 : freq <= (Ds4 << 2); // D#
            6'b001010 : freq <= (E4 << 2); // E
            6'b001011 : freq <= (Fs4 << 2); // F#
            6'b001100 : freq <= (Gs4 << 2); // G#
            6'b001101 :freq <= (As4 << 2); // A#
            6'b001110 :freq <= (B4 << 2); // B

            // octave 5
            6'b000000 : freq <= (C4 >> 1); // C4
            6'b000001 : freq <= (D4 >> 1); // D4
            6'b000010 : freq <= (E4 >> 1); // E4
            6'b000011 : freq <= (F4 >> 1); // F4
            6'b000100 : freq <= (G4 >> 1); // G4
            6'b000101 :freq <= (A4 >> 1); // A4
            6'b000110 :freq <= (B4 >> 1); // B4
            // accidentals, octave 5
            6'b001000 : freq <= (Cs4 >> 1); // C#
            6'b001001 : freq <= (Ds4 >> 1); // D#
            6'b001010 : freq <= (E4 >> 1); // E
            6'b001011 : freq <= (Fs4 >> 1); // F#
            6'b001100 : freq <= (Gs4 >> 1); // G#
            6'b001101 :freq <= (As4 >> 1); // A#
            6'b001110 :freq <= (B4 >> 1); // B
            default : freq <= 11'd440; // A4
        endcase
    end
endmodule

