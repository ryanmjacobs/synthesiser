// Module which displays the current note being played to the
// 7-segment display
module display(clk, freq, an, seg);
    input clk;
    input [11:0] freq;
    output reg [3:0] an;  // Controls the display digits
    output reg [6:0] seg; // Controls which digit to display
    
    // scan each digit
    wire pulse;
    reg [1:0] digit;
    display_pulse display_pulse_(clk, pulse);
    always @(posedge clk) begin
        if (pulse) begin
            digit <= digit + 1'b1;
            an <= ~(1 << digit);
        end

        case (digit)
            0 : seg <= 7'b1000011;
            1 : seg <= 7'b1001100;
            2 : seg <= 7'b1110000;
            3 : case (freq)
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
        endcase
    end
endmodule

// ~250 Hz
module display_pulse(input clk_in, output reg pulse_out);
    reg [18:0] count = 0;

    always @(posedge clk_in) begin
        if (count >= 200000) begin
            count <= 0;
            pulse_out <= 1;
        end else begin
            pulse_out <= 0;
            count <= count + 1'b1;
        end
    end
endmodule
