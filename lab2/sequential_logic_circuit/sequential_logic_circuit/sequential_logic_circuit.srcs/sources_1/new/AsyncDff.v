`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/25 23:41:29
// Design Name: 
// Module Name: AsyncDff
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


module AsyncDff(
    output reg q,
    input clk, rst, en, d
    );
    always @(posedge clk or posedge rst) begin
        if (rst) q <= 1'b0;
        else if (en) q <= d;
    end
endmodule
