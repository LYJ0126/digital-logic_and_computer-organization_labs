`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/15 17:41:18
// Design Name: 
// Module Name: decode3to8
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


module decode3to8(
    output [7:0] Out,
    input [2:0] In,
    input En
    );
    assign Out[0] =En ? (In==3'b000) : 0;
    assign Out[1] =En ? (In==3'b001) : 0;
    assign Out[2] =En ? (In==3'b010) : 0;
    assign Out[3] =En ? (In==3'b011) : 0;
    assign Out[4] =En ? (In==3'b100) : 0;
    assign Out[5] =En ? (In==3'b101) : 0;
    assign Out[6] =En ? (In==3'b110) : 0;
    assign Out[7] =En ? (In==3'b111) : 0;
endmodule
