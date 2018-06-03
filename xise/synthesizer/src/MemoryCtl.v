module MemoryCtrl(
  Clk, Reset, MemAdr, MemOE, MemWR,
  RamCS, RamUB, RamLB, RamAdv, RamCRE, writeData, AddressIn
);

 input Clk, Reset;
 input [22:0] AddressIn;
 output MemOE, MemWR, RamCS, RamUB, RamLB, RamAdv, RamCRE;
 output [26:1] MemAdr;
 output writeData;

 reg _MemOE, _MemWR, _RamCS, _RamUB, _RamLB, _RamAdv, _RamCRE;
 reg [22:0] address;

 reg [6:0] state;
 reg [6:0] clock_counter;
 reg writeData;
 
 assign MemAdr = {4'b0, address};
 assign MemOE = _MemOE;
 assign MemWR = _MemWR;
 assign RamCS = _RamCS;
 assign RamUB = _RamUB;
 assign RamLB = _RamLB;
 assign RamAdv = _RamAdv;
 assign RamCRE = _RamCRE;
 
localparam
 CONFIGMEM = 7'b0000001,
 CONFIGMEM2 = 7'b0000010,
 INIT = 7'b0000100,
 PREPARE_READ = 7'b0001000,
 WAIT = 7'b0010000,
 READ_DATA = 7'b0100000,
 IDLE = 7'b1000000;

always @ (posedge Clk, posedge Reset)
 begin : State_Machine
  if (Reset)
     begin
    state <= CONFIGMEM;
     end

  else 
     begin      
    case (state)
     CONFIGMEM:
      begin
       address <= 23'b000_10_00_0_1_011_1_0_0_0_0_01_1_111;
       _RamCRE <= 1;
       _RamAdv <= 0;
       _RamCS <= 0;
       _MemWR <= 0;
       _MemOE <= 1;
       _RamUB <= 1;
       _RamLB <= 1;
       writeData <= 0;
       clock_counter <= 0;
      end
     CONFIGMEM2:
      begin
       _RamCRE <= 1;
       _RamAdv <= 1;
       _RamCS <= 0;
       _MemWR <= 1;
       
       if(clock_counter == 7'b0000010)
        begin
         state <= INIT;
         _RamCS <= 1;
        end
       else
        clock_counter <= clock_counter + 1;
      end
     INIT:
      begin
       address <= AddressIn;
       state <= PREPARE_READ;
      end
     PREPARE_READ:
      begin
       _RamCRE <= 0;
       _RamAdv <= 0;
       _RamCS <= 0;
       _MemWR <= 1;
       _MemOE <= 1;
       _RamUB <= 0;
       _RamLB <= 0;
       state <= WAIT;
       clock_counter <= 0;
      end
     WAIT:
      begin
       _RamAdv <= 1;

       if(clock_counter == 7'b0000011)
        begin
         writeData <= 1;
         _MemOE <= 0;
         state <= READ_DATA;
         clock_counter <= 0;
        end
       else
        clock_counter <= clock_counter + 1;
      end
     READ_DATA:
      begin
       clock_counter <= clock_counter + 1;

       if(clock_counter == 7'b1111111)
        begin
         state <= IDLE;
         writeData <= 0;
        end
      end
     IDLE:
      begin
       _RamCRE <= 0;
       _RamAdv <= 1;
       _RamCS <= 1;
       _MemWR <= 1;
       _MemOE <= 1;
       _RamUB <= 1;
       _RamLB <= 1;
      end
     default:
      state <= 7'bXXXXXXX;
    endcase
   end
  end
endmodule
