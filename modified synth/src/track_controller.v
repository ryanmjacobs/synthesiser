module track_controller(clk, cycle_sig, play_sig, current_track, tracks_playing, trackonestatus, tracktwostatus);
    input clk;
    input cycle_sig;
    input play_sig;

    output reg current_track;
    output [1:0] tracks_playing;
    output trackonestatus, tracktwostatus;

    assign trackonestatus = trackone;
    assign tracktwostatus = tracktwo;

    reg trackone = 0, tracktwo = 0;

    initial begin
        current_track = 0;
    end

    assign tracks_playing = {tracktwo, trackone};

    always @(posedge clk) begin
        if (cycle_sig)
            current_track <= ~current_track;

        if (play_sig) begin
            if (current_track == 0)
                trackone <= ~trackone;
            else 
                tracktwo <= ~tracktwo;
        end
    end
endmodule
