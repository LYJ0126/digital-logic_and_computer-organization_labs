`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/25 23:42:44
// Design Name: 
// Module Name: reg8
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


module reg8(
    output reg [7:0] Q,
    output [7:0] QN,
    input [7:0] D,
    input CLK, PRE_L, CLR_L, WE
    );
    always @ (posedge CLK or negedge CLR_L or negedge PRE_L)
        if (CLR_L==0) Q <= 0;
        else if (PRE_L==0) Q<=255;
        else if (WE==1) Q <= D;
    assign QN=~Q;
endmodule
