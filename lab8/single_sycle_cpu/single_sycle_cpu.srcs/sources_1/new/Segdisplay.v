`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/28 00:33:50
// Design Name: 
// Module Name: Segdisplay
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


module Segdisplay(
input clk,
input [31:0] value,
output reg [6:0] segs,
output reg [7:0] AN
    );
    reg [31:0] cnt;
reg [2:0] pos;
reg [6:0] seg_store [15:0];

initial begin
    cnt = 32'b0;
    pos = 3'b0;
    seg_store[0] = 7'b1000000;
    seg_store[1] = 7'b1111001;
    seg_store[2] = 7'b0100100;
    seg_store[3] = 7'b0110000;
    seg_store[4] = 7'b0011001;
    seg_store[5] = 7'b0010010;
    seg_store[6] = 7'b0000010;
    seg_store[7] = 7'b1111000;
    seg_store[8] = 7'b0000000;
    seg_store[9] = 7'b0010000;
    seg_store[10] = 7'b0001000;
    seg_store[11] = 7'b0000011;
    seg_store[12] = 7'b1000110;
    seg_store[13] = 7'b0100001;
    seg_store[14] = 7'b0000110;
    seg_store[15] = 7'b0001110;
end

always @(posedge clk) begin
    cnt <= (cnt + 1) % 10000;
    if (cnt == 0) begin
        pos <= (pos + 1) % 8;
    end
    AN <= 8'b11111111 - (1 << pos);
    segs <= seg_store[value[4 * pos +: 4]];
end
endmodule
