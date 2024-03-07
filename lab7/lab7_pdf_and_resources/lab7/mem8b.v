`timescale 1ns / 1ps

module mem8b(
   output reg [7:0] dataout,   //输出数据
   input cs,                   //片选信号，高电平有效。有效时，存储器正常工作
   input clk,                   //时钟信号
   input we,                   //存储器写使能信号，高电平时允许写入数据
   input [7:0] datain,        //下输入数据
   input [15:0] addr           //16位存储器地址，存储容量64KB
);
 (* ram_style="block" *) reg [7:0] ram [2**16-1:0];  //设置使用块RAM综合成存储器
// Add your code here
always @(negedge clk) begin
        if (cs && we)
            ram[addr] <= datain;
end
always @(posedge clk) begin
    if (cs)
        dataout <= ram[addr];
end
endmodule