`timescale 1ns / 100ps
module async_controller( input         clk,
                                       WE,
                         input  [7:0]  data_write,
                         inout  [15:0] MemDB,
                         output        RamAdv,
													RamClk,
													RamCS,
                                       MemOE,
                                       MemWR,
                                       RamLB,
                                       RamUB,
                         output [3:0]  an,
                         output [7:0]  seg,
//                       output [15:0] data_read,
                         output [22:0] MemAdr );

   reg [3:0] addr = 0;
   assign MemAdr = { { 19{1'b0} }, addr };

   reg        WR;
   reg [15:0] data_read;

   assign MemDB = ( WR ) ? {data_write, data_write} : 16'bZ;	
   always @( posedge clk ) begin
      data_read = MemDB;
      WR <= WE;		
   end

    // advance audio slices at ~32khz
    wire ap;
    audio_pulse _audio_pulse(clk, ap);
    always @(posedge clk) begin
        if (ap) begin
            addr <= addr + 1'b1;
        end
    end

   async_fsm async( clk,
                    WR,
						  RamAdv,
						  RamClk,
                    RamCS,
                    MemOE,
                    MemWR,
                    RamLB,
                    RamUB );

   disp_hex_mux hex_display( clk,
                             1'b0,
                             data_read[15:12],
                             data_read[11:8],
                             data_read[7:4],
                             data_read[3:0],
                             4'hf,
                             an,
                             seg );

        
endmodule

// Generates a pulse at a rate of 31.5 KHz for the audio loop
module audio_pulse(input clk_in, output reg pulse_out);
  //reg [11:0] count = 0;
    reg [26:0] count = 0;

    // TMP: 1hz pulse
    always @(posedge clk_in) begin
      //if (count >= 3200) begin
        if (count >= 10_000_000) begin
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