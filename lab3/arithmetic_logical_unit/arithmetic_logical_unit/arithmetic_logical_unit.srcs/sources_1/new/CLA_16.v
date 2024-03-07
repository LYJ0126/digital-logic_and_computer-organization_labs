`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/29 14:19:36
// Design Name: 
// Module Name: CLA_16
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

//使用结构化建模方式实现的 16 位先行进位的模块
module CLA_16(
    output wire [15:0] f,
    output wire cout, 
    input [15:0] x, y,
    input cin
    );
    wire [3:0] Pi,Gi; // 4 位组间进位传递因子和生成因子
    wire [4:0] c; // 4 位组间进位和整体进位
    assign c[0] = cin;
    CLA_group cla0(.f(f[3:0]),.pg(Pi[0]),.gg(Gi[0]),.x(x[3:0]),.y(y[3:0]),.cin(c[0]));
    CLA_group cla1(.f(f[7:4]),.pg(Pi[1]),.gg(Gi[1]),.x(x[7:4]),.y(y[7:4]),.cin(c[1]));
    CLA_group cla2(.f(f[11:8]),.pg(Pi[2]),.gg(Gi[2]),.x(x[11:8]),.y(y[11:8]),.cin(c[2]));
    CLA_group cla3(.f(f[15:12]),.pg(Pi[3]),.gg(Gi[3]),.x(x[15:12]),.y(y[15:12]),.cin(c[3]));
    CLU clu(.c(c[4:1]),.p(Pi),.g(Gi), .c0(c[0]));
    assign cout = c[4];
endmodule
