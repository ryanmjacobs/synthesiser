`timescale 1ns / 1ps

// Pmod keypad input module which allows user to choose which note
// (frequency) to play
module sw_interface(clk, sw, freq);
    input clk;
    input [5:0] sw;
    output [11:0] freq;
    
    reg [3:0] Col;
    reg [11:0] freq;
    
    initial begin
        freq <= 440;    // Default note A
    end

    always @(posedge clk)
    begin
        // If sw[3] is set, sw[2:0] moves up half a step (unless E or B)
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
        end
        
        // Octave shifter
        case (sw[5:4])
            1: freq <= freq <<1;
            2: freq <= freq << 2;
            3: freq <= freq >> 1;
        endcase
    end
endmodule

