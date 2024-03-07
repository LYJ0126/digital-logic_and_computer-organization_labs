`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/29 14:18:28
// Design Name: 
// Module Name: CLA_group
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

//支持生成组件进位传递因子和进位因子的4 位组间先行进位加法器模块
module CLA_group(
    output [3:0] f,
    output pg,gg,
    input [3:0] x, y,
    input cin
    );
    wire [4:0] c;
    wire [4:1] p, g;
    assign c[0] = cin;
    FA_PG fa0(.f(f[0]), .p(p[1]), .g(g[1]),.x(x[0]), .y(y[0]), .cin(c[0]));
    FA_PG fa1(.f(f[1]), .p(p[2]), .g(g[2]),.x(x[1]), .y(y[1]), .cin(c[1]));
    FA_PG fa2(.f(f[2]), .p(p[3]), .g(g[3]),.x(x[2]), .y(y[2]), .cin(c[2]));
    FA_PG fa3(.f(f[3]), .p(p[4]), .g(g[4]),.x(x[3]), .y(y[3]), .cin(c[3]));
    CLU clu(.c(c[4:1]),.p(p), .g(g), .c0(c[0]));
    assign pg=p[1] & p[2] & p[3] & p[4];
    assign gg= g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | (p[4] & p[3] & p[2] & g[1]);
endmodule
