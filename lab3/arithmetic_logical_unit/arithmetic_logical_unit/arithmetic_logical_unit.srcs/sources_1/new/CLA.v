`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/29 14:15:51
// Design Name: 
// Module Name: CLA
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

//4 位先行进位加法器
module CLA(
    output [3:0] f,
    output cout,
    input [3:0] x, y,
    input cin
    );
    wire [4:0] c;
    wire [4:1] p, g;
    assign c[0] = cin;
    FA_PG fa0(f[0], p[1], g[1],x[0], y[0], c[0]);
    FA_PG fa1(f[1], p[2], g[2],x[1], y[1], c[1]);
    FA_PG fa2(f[2], p[3], g[3],x[2], y[2], c[2]);
    FA_PG fa3(f[3], p[4], g[4],x[3], y[3], c[3]);
    CLU clu(c[4:1],p, g, c[0]);
    assign cout = c[4];
endmodule
