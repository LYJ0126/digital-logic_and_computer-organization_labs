`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/15 15:58:32
// Design Name: 
// Module Name: mux4to1
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


module mux4to1(
    output reg [2:0] y, // 注意此处 y 类型为 reg。
    input [2:0]d0,d1,d2,d3, // 声明 4 个 wire 型输入变量 d0-d3，其宽度为 3 位。
    input [1:0]s // 声明 1 个 wire 型输入变量 s，其宽度为 2 位。
    );
    always @(*) //相当于 @( s0, s1, d0, d1, d2, d3)
        case (s)
            2'b00: y=d0;
            2'b01: y=d1;
            2'b10: y=d2;
            2'b11: y=d3;
        endcase
endmodule
