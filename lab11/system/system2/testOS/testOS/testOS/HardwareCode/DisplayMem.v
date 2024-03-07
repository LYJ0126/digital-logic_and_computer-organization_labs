`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2023 08:32:53 PM
// Design Name: 
// Module Name: DisplayMem
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


module DisplayMem(
	output [19:0]dataout,
	output reg [7:0]start_line,
	input [12:0] rdaddr,
	input [12:0] wraddr,
	input  [31:0] datain,
	input we,
	input  wrclk
	);

reg [19:0] ram [4480:0];
assign dataout = ram[rdaddr];
always@(posedge wrclk)
    if(we) begin       
    if(wraddr == 13'b1111111111111)//start_line的约定
        start_line <= datain[7:0];
    else
        ram[wraddr] <= datain [19:0];
    end
endmodule