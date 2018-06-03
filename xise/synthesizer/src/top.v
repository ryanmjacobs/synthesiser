module top(
    input rst,
	input clk,
    output reg [7:0] led,

    output [7:0] phase,
    output [7:0] s,

    output MemOE,
    output MemWR,
    output MemClk,
    output RamCS,
    output RamUB,
    output RamLB,
    output RamAdv,
    output RamCRE,
    output [26:1] MemAdr
);

initial led <= 8'b10101010;

//////////////////////////////////////////////////////////////////////////////
// Testing RAM
//////////////////////////////////////////////////////////////////////////////
reg [26:0] DIV_CLK;
assign MemClk = DIV_CLK[0];

always @(posedge clk) begin
    if (rst)
        DIV_CLK <= 0;
    else
        DIV_CLK <= DIV_CLK + 1;
end

wire [22:0] address;
MemoryCtrl memory(
    .Clk(MemClk), .Reset(rst), .MemAdr(MemAdr), .MemOE(MemOE), .MemWR(MemWR),
    .RamCS(RamCS), .RamUB(RamUB), .RamLB(RamLB), .RamAdv(RamAdv), .RamCRE(RamCRE),
    .writeData(writeData), .AddressIn(address)
);

//////////////////////////////////////////////////////////////////////////////
// END Testing RAM
//////////////////////////////////////////////////////////////////////////////

endmodule
