`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2022 02:57:25 PM
// Design Name: 
// Module Name: decode
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


module decode(
    input [31:0] instr,
    output [6:0] op,
    output [4:0] rs1,
    output [4:0] rs2,
    output [4:0] rd,
    output [2:0] func3,
    output [6:0] func7
    );
    assign op = instr[6:0];
	assign rs1 = instr[19:15];
	assign rs2 = instr[24:20];
	assign rd = instr[11:7];
	assign func3 = instr[14:12];
	assign func7 = instr[31:25]; 
endmodule
