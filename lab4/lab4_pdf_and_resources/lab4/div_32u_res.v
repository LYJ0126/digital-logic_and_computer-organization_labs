`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/03 09:09:44
// Design Name: 
// Module Name: div_32u_unres
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//parameter N =32;
module div_32u_res(
    output  [31:0] Q,          //商
    output  [31:0] R,          //余数
    output out_valid,        //除法运算结束时，输出为1
    output in_error,         //被除数或除数为0时，输出为1
    input clk,               //时钟 
    input rst,             //复位信号
    input [31:0] X,           //被除数
    input [31:0] Y,           //除数
    input in_valid          //输入为1时，表示数据准备好了，开始除法运算
   );
   // add your code here
endmodule
