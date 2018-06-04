// 100 MHz scale
`timescale 10ns/10ns

module ram_tb;
    reg clk;
    reg rst;
    reg write_enable;
    reg [15:0] data_write;
    inout [15:0] MemDB;
    wire [15:0] data_read;

    wire RamAdv, RamClk, RamCS, MemOE, MemWR, RamLB, RamUB;
    wire [26:1] MemAdr;

    wire [7:0] Led;

    ram ram_(clk, rst, write_enable, data_write, MemDB, data_read,
        MemAdv, MemClk, RamCS, MemOE, MemWR, RamLB, RamUB, MemAdr, Led);

    initial begin
        $display("--- ram tb ---");
        $dumpfile("ram.vcd");
        $dumpvars(0, ram_tb);
    end

    initial begin
        clk = 0;

        #2 rst = 1;
        #2 rst = 0;
        #32e3 $finish;
    end

    always #1 clk <= ~clk;
endmodule
