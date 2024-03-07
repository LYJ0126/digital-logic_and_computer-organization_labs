`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/29 18:23:57
// Design Name: 
// Module Name: mux32b
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


module mux32b(
    output [31:0] out,
    input  s,
    input [31:0] a,b
    );
    assign out=(s)?b:a;
endmodule
