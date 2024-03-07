`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2022 03:56:01 PM
// Design Name: 
// Module Name: pcgen
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


module pcgen(
    input [31:0] PC,
    input [31:0] imm,
    input [31:0] busA,
    input PCASrc,
    input PCBSrc,
    input reset,
    
    output [31:0] NEXTPC
    );
    assign NEXTPC = reset ? 32'd0 : ((PCASrc ? imm : 32'd4) + (PCBSrc ? busA : PC));
    
endmodule
