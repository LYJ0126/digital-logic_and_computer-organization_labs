`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/16 19:28:38
// Design Name: 
// Module Name: compare32b
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


module compare32b(
    output PGTQ, PEQQ, PLTQ,//PGTQ大于，PEEQ，等于，PLTQ小于
    input [31:0] P,Q
    );
    assign PGTQ = ((P>Q)?1'b1:1'b0);
    assign PEQQ = ((P==Q)?1'b1:1'b0);
    assign PLTQ = ~PGTQ&~PEQQ;
endmodule