module ram(
    input clk,
    input rst,
    input write_enable,
    input [15:0] data_write,
    inout [15:0] MemDB,
    output [15:0] data_read,

    output RamAdv, RamClk, RamCS, MemOE, MemWR, RamLB, RamUB,
    output [22:0] MemAdr
);
    // address
    reg [19:0] addr = 0;
    assign MemAdr = {3'b0, addr};

    // tmp write enable? and enable
    wire WE, EN;
    assign WE = write_enable;
    assign EN = 1;

    // read and write db
    reg WR, CS;
    reg [15:0] data_read;
    assign MemDB = (WR) ? data_write : 16'bZ;

    always @(posedge clk) begin
        data_read = MemDB;
        WR <= WE;
        CS <= EN;
    end

    // advance audio slices at ~32khz
    wire ap;
    audio_pulse _audio_pulse(clk, ap);
    always @(posedge clk) begin
        if (ap) begin
            if (addr >= 384_000)
                addr <= 0;
            else
                addr <= addr + 1'b1;
        end
    end

    async_fsm async(clk, WR, CS, RamAdv, RamClk, RamCS, MemOE, MemWR, RamLB, RamUB);
endmodule

// Generates a pulse at a rate of 31.5 KHz for the audio loop
module audio_pulse(input clk_in, output reg pulse_out);
    reg [11:0] count = 0;

    always @(posedge clk_in) begin
        if (count >= 3200) begin
            pulse_out <= 1;
            count <= count + 1'b1;
        end else begin
            count <= 0;
            pulse_out <= 0;
        end
    end
endmodule

module async_fsm(
    input clk, WR, CS,
    output RamAdv, RamClk, RamCS, MemOE, MemWR, RamLB, RamUB);

    localparam
      READY = 2'b00,
      READ  = 2'b01,
      WRITE = 2'b10,
      IDLE  = 7'b1111111,
      CYCLES_TO_WAIT = 3'd6;

   reg [1:0] current, next;
   reg [2:0] cycle_count;

   reg [6:0] controls;
   assign { RamAdv, RamClk, RamCS, MemOE, MemWR, RamLB, RamUB } = controls;

   initial begin
      current     <= READY;
      next        <= READY;
      cycle_count <= 3'd0;
      controls    <= IDLE;
   end

   always @(posedge clk) begin
      current     <= next;
      cycle_count <= ( READY == current ) ? 3'd0 : cycle_count + 1'b1;
   end

   always @(*) begin
      case (current)
         READY: begin
            next     <= ( CS ) ?
                        ( ( WR ) ? WRITE : READ ) :
                        READY;
            controls <= IDLE;
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
            controls <= IDLE;
         end
      endcase
   end
endmodule
