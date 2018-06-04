module top(
    input rst,
	input clk,
    output reg [7:0] led,
    input [7:0] sw,
    inout [15:0] MemDB,

    output RamAdv, RamClk, RamCS, MemOE, MemWR, RamLB, RamUB,
    output [26:1] MemAdr,
    
    output [15:0] data_read
);

//reg write_enable = 0;
wire write_enable;
//wire [15:0] data_read;

wire [15:0] data_write;
assign data_write = sw;
assign write_enable = sw[0];

ram ram_(
    .clk(clk),
    .rst(rst),

    .write_enable(write_enable),
    .data_write(data_write),
    .MemDB(MemDB),
    .data_read(data_read),

    .RamAdv(RamAdv),
    .RamClk(RamClk),
    .RamCS(RamCS),
    .MemOE(MemOE),
    .MemWR(MemWR),
    .RamLB(RamLB),
    .RamUB(RamUB),
    .MemAdr(MemAdr)
);

always @(*) begin
    if (rst)
        led <= 8'b0;
    else
        led [7:0] <= data_read;
end

endmodule
