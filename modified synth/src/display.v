// Module which displays the current note being played to the
// 7-segment display
module display(freq, an, seg);
    input [11:0] freq;
    output [3:0] an;     // Controls the display digits
    output reg [6:0] seg;    // Controls which digit to display
    
    // Output wires and registers
    wire [3:0] an;
    
    // Only display the rightmost digit
    assign an = 4'b1110;
    
    always @(freq) begin
        case (freq)                     // Musical notes:
            261 : seg <= 7'b1000110; // C
            277 : seg <= 7'b1000110; // C#
            293 : seg <= 7'b0100001; // D
            311 : seg <= 7'b0100001; // D#
            330 : seg <= 7'b0000110; // E
            349 : seg <= 7'b0001110; // F
            370 : seg <= 7'b0001110; // F#
            392 : seg <= 7'b0010000; // G
            415 : seg <= 7'b0010000; // G#
            440 : seg <= 7'b0001000; // A
            466 : seg <= 7'b0001000; // A#
            494 : seg <= 7'b0000011; // B
            default : seg <= 7'b0111111;
        endcase
    end
endmodule
