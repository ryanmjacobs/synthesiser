// Module which displays the current note being played to the
// 7-segment display
module display(clk, note, octave, accident, an, seg);
    input clk;
    input [2:0] note;
    input [1:0] octave;
    input accident;

    output reg [3:0] an;  // Controls the display digits
    output reg [7:0] seg; // Controls which digit to display
    
    // scan each digit
    wire pulse;
    reg [1:0] digit = 0;
    display_pulse display_pulse_(clk, pulse);
    always @(posedge clk) begin
        if (pulse) begin
            digit <= digit + 1'b1;
            an <= ~(1 << digit);
        end

        case (an)
            4'b0111 : seg <= 8'b11000011;
            4'b1011 : seg <= 8'b11001100;
            4'b1101 : case (note)
                0 : seg <= 8'b11000110; // C
                1 : seg <= 8'b10100001; // D
                2 : seg <= 8'b10000110; // E
                3 : seg <= 8'b10001110; // F
                4 : seg <= 8'b10010000; // G
                5 : seg <= 8'b10001000; // A
                6 : seg <= 8'b10000011; // B
                default : seg <= 8'b10001000;
            endcase

            4'b1110 : case (octave)
                0 : seg <= {~accident, 7'b0011001};
                1 : seg <= {~accident, 7'b0010010};
                2 : seg <= {~accident, 7'b0000010};
                3 : seg <= {~accident, 7'b0110000};
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
