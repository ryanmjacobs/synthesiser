// Module which accumulates the waveforms chosen by the nexys 3 switches
// into the total output signal
// Allows user to play multiple types of waveforms simultaneously
module sig_adder(clk, sw, btn, sig_square, sig_saw, sig_tri, sig_sine, sig_mem, sig);
    input clk;                  // 1MHz clock
    input [7:6] sw;             // Switches on FPGA
    input btn;
    input [15:0] sig_square;
    input [15:0] sig_saw;
    input [15:0] sig_tri;
    input [15:0] sig_sine;
    input [15:0] sig_mem;

    output reg [15:0] sig;      // Total output signal
    
    reg [15:0] sig_temp;
    reg [15:0] sig_noise;

    initial begin
        sig <= 0;
        sig_temp <= 0;
        sig_noise <= 773;
    end
    
    // Accumulate chosen waveforms
    always @(posedge clk)
    begin
        sig_temp = 0;
        if (btn) begin
            if (sw[7:6] == 0) begin
                sig_temp = sig_temp + sig_square + sig_saw;
            end //else if (sw[7:6] == 1) begin
                //sig_temp = sig_temp + sig_tri + sig_sine;
            //end
        end
        // Generates random noise
        /*
        if (sw[4] == 1) begin
            sig_noise = { sig_noise[14:0], sig_noise[15] ^ sig_noise[14] ^ sig_noise[12] ^ sig_noise[3] };
            sig_temp = sig_temp + sig_noise;
        end*/
        
        sig = sig_temp + sig_mem;
    end

endmodule
