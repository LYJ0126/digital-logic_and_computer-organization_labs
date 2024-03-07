`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/03 19:52:31
// Design Name: 
// Module Name: ALUmux
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


module ALUmux(
    output reg [31:0] result,
    input [2:0] select,
    input [31:0] in0,in1,in2,in3,in4,in5,in6
    );
    always @(*)
        case(select)
            3'b000: result=in0;
            3'b001: result=in1;
            3'b010: result=in2;
            3'b011: result=in3;
            3'b100: result=in4;
            3'b101: result=in5;
            3'b110: result=in6;
            default: result=8'h00000000;
        endcase
endmodule
