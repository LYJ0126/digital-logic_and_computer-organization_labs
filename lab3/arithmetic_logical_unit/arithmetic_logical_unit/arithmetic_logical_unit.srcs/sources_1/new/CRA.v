`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/29 14:11:13
// Design Name: 
// Module Name: CRA
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

//四位串行加法器
module CRA(
    output [3:0] f,
    output cout,
    input [3:0] x, y,
    input cin
    );
    wire [4:0] c;
    assign c[0] = cin;
    FA fa0(f[0], c[1], x[0], y[0], c[0]);
    FA fa1(f[1], c[2], x[1], y[1], c[1]);
    FA fa2(f[2], c[3], x[2], y[2], c[2]);
    FA fa3(f[3], c[4], x[3], y[3], c[3]);
    assign cout = c[4];
endmodule
