`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/28 15:36:00
// Design Name: 
// Module Name: scancode_ram
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


module scancode_ram(
clk, addr,outdata);
input clk;
input [7:0] addr;
output reg [7:0] outdata;

reg [7:0] myrom[255:0];

initial
begin
    $readmemh("scancode.txt", myrom, 0, 255);
end

always @(posedge clk)
begin
      outdata <= myrom[addr];
end
endmodule
