`timescale 1ns / 1ps

module DataMem(
   output reg [31:0] dataout,      //数据输出
   input clk,                   //时钟信号
   input we,                   //存储器写使能信号，高电平时允许写入数据
   input [2:0] MemOp,          //读写字节数控制
   input [31:0] datain,          //下输入数据
   input [15:0] addr            //存储器地址
);
(* ram_style="block" *)  reg [31:0] ram [2**16-1:0];  //设置使用块RAM综合成存储器

//Add your code here
endmodule
