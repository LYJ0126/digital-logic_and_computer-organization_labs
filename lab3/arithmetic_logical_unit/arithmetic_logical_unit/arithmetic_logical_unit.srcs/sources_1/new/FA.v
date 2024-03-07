`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/29 14:10:09
// Design Name: 
// Module Name: FA
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

//È«¼ÓÆ÷
module FA(
    output f,cout,
    input x,y,cin
    );
    assign f= x ^ y ^ cin;
    assign cout=( x & y) | (x & cin ) | ( y & cin);
endmodule
