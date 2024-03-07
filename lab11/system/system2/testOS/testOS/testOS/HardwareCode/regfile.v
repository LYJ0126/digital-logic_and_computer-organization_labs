`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2022 02:40:49 PM
// Design Name: 
// Module Name: regfile
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


module regfile(
    input [4:0] Ra,
    input [4:0] Rb,
    input [4:0] Rw,
    input [31:0] busW,
    input  RegWr,
    input  WrClk,

    output [31:0] busA,
    output [31:0] busB
);
    reg [31:0] regs[31:0];
    integer i;
    initial begin
		for (i = 0; i <= 31; i = i + 1) begin
			regs[i] = 32'd0;
		end
	end
    assign busA = regs[Ra];
    assign busB = regs[Rb];
    always @(posedge WrClk )
    if(RegWr && Rw)
        regs[Rw] = busW;

endmodule
