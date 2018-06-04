
module top(
    input rst,
	input clk,
    output [7:0] led,
    input [7:0] sw,
    inout [15:0] MemDB,

    output MemAdv, MemClk, RamCS, MemOE, MemWR, RamLB, RamUB,
    output [26:1] MemAdr
);

//reg write_enable = 0;
wire write_enable;
wire [15:0] data_read;

wire [15:0] write_data;
assign write_data = sw;
assign write_enable = sw[0];

ram ram_(clk, rst, write_enable, write_data, MemDB, data_read,
    MemAdv, MemClk, RamCS, MemOE, MemWR, RamLB, RamUB, MemAdr);

always @(*) begin
    if (rst)
        led <= 8'b0;
    else
        led [7:0] <= data_read;
end

endmodule
