`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/15 15:58:57
// Design Name: 
// Module Name: dmux1to4
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


module dmux1to4(
    output [2:0] d0,d1,d2,d3, //4 路 3 位的输出信号 d0~d3。
    input [2:0] d, // 3 位输入信号 d。
    input [1:0] s // 2 位选择控制信号 s。
    );
    assign d0 = ( ~s[1] & ~s[0] ) ? d : 3'bz;
    assign d1 = ( ~s[1] & s[0] ) ? d : 3'bz;
    assign d2 = ( s[1] & ~s[0] ) ? d : 3'bz;
    assign d3 = ( s[1] & s[0] ) ? d : 3'bz;
endmodule
