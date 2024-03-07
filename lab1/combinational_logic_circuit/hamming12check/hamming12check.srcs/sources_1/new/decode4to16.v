`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/20 16:40:25
// Design Name: 
// Module Name: decode4to16
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


module decode4to16(
    output [15:0] Out,
    input [3:0] In,
    input En
    );
    assign Out =En ? (1<<In) : 0;
endmodule
