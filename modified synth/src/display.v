`timescale 1ns / 1ps

// Module which displays the current note being played to the
// 7-segment display
module display(freq, anode, segOut);
    input [11:0] freq;
    output [3:0] anode;     // Controls the display digits
    output reg [6:0] segOut;    // Controls which digit to display
    
    // Output wires and registers
    wire [3:0] anode;
    
    // Only display the rightmost digit
    assign anode = 4'b1110;
    
    always @(freq) begin
        case (freq)                     // Musical notes:
            261 : segOut <= 7'b1000110; // C
            277 : segOut <= 7'b1000110; // C#
            293 : segOut <= 7'b0100001; // D
            311 : segOut <= 7'b0100001; // D#
            330 : segOut <= 7'b0000110; // E
            349 : segOut <= 7'b0001110; // F
            370 : segOut <= 7'b0001110; // F#
            392 : segOut <= 7'b0010000; // G
            415 : segOut <= 7'b0010000; // G#
            440 : segOut <= 7'b0001000; // A
            466 : segOut <= 7'b0001000; // A#
            494 : segOut <= 7'b0000011; // B
            default : segOut <= 7'b0111111;
        endcase
    end
endmodule
