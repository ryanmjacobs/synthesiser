`timescale 1ns / 100ps
module async_controller(
    input clk, WR,
    input [15:0] data_write,

    // track input realtime config
    input track_writing,
    input [1:0] tracks_playing,

    inout  [15:0] MemDB,
    output [22:0] MemAdr,
    output RamAdv, RamClk, RamCS, MemOE, MemWR, RamLB, RamUB,
    output reg [15:0] data_read
);
    // Pad our MemAddress with zeroes
    reg [21:0] addr = 0;
    assign MemAdr = { {1'b0}, addr };

    // store tracks 1 and 2
    reg cur_track = 0;
    reg [15:0] track1 = 0;
    reg [15:0] track2 = 0;
    
    // Continually copy MemDB to our data_read
    wire write;
    assign write = (WR && (track_writing == cur_track));
    assign MemDB = write ? data_write : 16'bZ;

    always @(posedge clk) begin
        if (cur_track == 0)
            track1 = (tracks_playing & 2'b01) ? MemDB : 16'b0;
        else
            track2 = (tracks_playing & 2'b10) ? MemDB : 16'b0;
    end
    
    // advance audio slices at ~32khz
    wire ap;
    audio_pulse _audio_pulse(clk, ap);
    always @(posedge clk) begin
        if (ap) begin
            addr <= addr + 1'b1;
            cur_track <= ~cur_track;

            if (cur_track == 0)
                data_read <= track1 + track2;
        end
    end
    
    async_fsm async(clk, WR, RamAdv, RamClk, RamCS, MemOE, MemWR, RamLB, RamUB);
endmodule

// Generates a pulse at a rate of ~62KHz for the audio loop
// (two tracks)
module audio_pulse(input clk_in, output reg pulse_out);
    reg [7:0] count = 0;

    always @(posedge clk_in) begin
        if (count >= 100) begin
            count <= 0;
            pulse_out <= 1;
        end else begin
            pulse_out <= 0;
            count <= count + 1'b1;
        end
    end
endmodule

module async_fsm( input  clk,
                         WR,
                  output RamAdv,
                 RamClk,
                 RamCS,
                         MemOE,
                         MemWR,
                         RamLB,
                         RamUB );
   localparam
      READY = 2'b00,
      READ  = 2'b01,
      WRITE = 2'b10,

      INACTIVE = 7'b1111111,

      CYCLES_TO_WAIT = 3'd6;

   reg [1:0] current, next;
   reg [2:0] cycle_count;

   reg [6:0] controls;
   assign { RamAdv, RamClk, RamCS, MemOE, MemWR, RamLB, RamUB } = controls;

   initial begin
      current     <= READY;
      next        <= READY;
      cycle_count <= 3'd0;
      controls    <= INACTIVE;
   end

   always @( posedge clk ) begin
      current     <= next;
      cycle_count <= ( READY == current ) ? 3'd0 :
      cycle_count + 1'b1;
   end

   always @( * ) begin
      case( current )
         READY:   begin
            next     <= ( ( WR ) ? WRITE : READ );
            controls <= INACTIVE;
         end
         READ:    begin
            next     <= ( CYCLES_TO_WAIT == cycle_count ) ? READY : READ;
            controls <= 7'b0000100;
         end
         WRITE:   begin
            next     <= ( CYCLES_TO_WAIT == cycle_count ) ? READY : WRITE;
            controls <= 7'b0001000;
         end
         default: begin
            next     <= READY;
            controls <= INACTIVE;
         end
      endcase
   end
endmodule
