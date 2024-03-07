`timescale 1ns / 1ps

module ALU32(
   output  [31:0] result,      //32位运算结果
   output  zero,               //结果为0标志位
   input   [31:0] dataa,      //32位数据输入，送到ALU端口A   
   input   [31:0] datab,      //32位数据输入，送到ALU端口B  
   input   [3:0] aluctr      //4位ALU操作控制信号
); 
//add your code here
endmodule
