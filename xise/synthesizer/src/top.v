module top(
    input rst,
	input clk,
    output reg [7:0] led,

    output reg mclk,
    output reg lrck,
    output reg sck,
    output reg sdout,

    output [7:0] phase,
    output [7:0] s
);

initial led <= 8'b10101010;

reg lrck;
reg [3:0]  pos = 0;
reg [15:0] data = 16'b0001_1000;

wire mclk_pulse;
wire lrck_pulse;
clkdiv clkdiv(rst, clk, mclk_pulse, lrck_pulse);

// sine wave table
reg [7:0] phase = 0;
reg	[6:0] sine [0:255];
assign s = sine[phase];
initial $readmemh("sine.hex", sine);

always @(posedge clk) begin
    // initial states
    if (rst) begin
        mclk  <= 0;
        lrck  <= 0;
        sck   <= 1;
        sdout <= 0;
    end else begin
        if (mclk_pulse)
            mclk <= ~mclk;

        if (lrck_pulse)
            lrck <= ~lrck;

        // reset position when we switch from
        // Left to Right (or vice versa)
        if (lrck) begin
            phase <= phase + 1;
            data <= sine[phase];
            data <= sine[phase] + sine[phase] << 8;
            pos <= 0;
        end

        // shift the data out on each mclk
        // TODO: this should be sck?
        if (mclk) begin
            sck <= 0;
            pos <= pos + 1;
            sdout <= (data >> ~pos);

            if (pos == 15)
                lrck <= ~lrck;
        end else begin
            sck <= 1;
        end
    end
end

endmodule
