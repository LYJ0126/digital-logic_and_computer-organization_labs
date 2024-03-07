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


module immgen(
    input [31:0] instr,
    input [2:0] ExtOP,
    output [31:0] imm
    );
    wire [31:0] immregs[4:0];
    assign immregs[0] = {{20{instr[31]}}, instr[31:20]};//immI
	assign immregs[1] = {instr[31:12], 12'b0};//immU
	assign immregs[2] = {{20{instr[31]}}, instr[31:25], instr[11:7]};//immS
	assign immregs[3] = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};//immB
	assign immregs[4] = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};//immJ
	assign imm = immregs[ExtOP];
endmodule
