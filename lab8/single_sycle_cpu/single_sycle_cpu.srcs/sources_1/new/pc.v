`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/27 23:08:36
// Design Name: 
// Module Name: pc
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


module pc(
input [31:0] nxtPC,
input Reset,
input clk,
output reg [31:0] PC
    );
    always @(posedge clk) begin
    if (Reset) PC = 0;
    else PC = nxtPC;
end
endmodule
