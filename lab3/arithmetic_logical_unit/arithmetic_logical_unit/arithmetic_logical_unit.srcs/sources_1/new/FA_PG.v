`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/29 14:13:10
// Design Name: 
// Module Name: FA_PG
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

//输出进位因子和传递因子的全加器
module FA_PG(
    output f, p, g,
    input x, y, cin
    );
    assign f = x ^ y ^ cin;
    assign p = x | y;
    assign g = x & y;
endmodule
