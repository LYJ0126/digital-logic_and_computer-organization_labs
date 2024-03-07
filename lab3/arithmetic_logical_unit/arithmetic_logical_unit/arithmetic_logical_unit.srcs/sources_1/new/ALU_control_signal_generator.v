`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/02 21:53:46
// Design Name: 
// Module Name: ALU_control_signal_generator
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


module ALU_control_signal_generator(
    output SUBctr,SIGctr,ALctr,SFTctr,
    output [2:0] OPctr,
    input [3:0] ALUctr
    );
    assign SUBctr=ALUctr[1]||(ALUctr[0]&&ALUctr[1])||ALUctr[3];
    assign SIGctr=~ALUctr[0];
    assign ALctr=ALUctr[3];
    assign SFTctr=~ALUctr[2];
    assign OPctr[0]=(ALUctr==4'b0100)||(ALUctr==4'b0111)||(ALUctr==4'b1111);
    assign OPctr[1]=(ALUctr==4'b0010)||(ALUctr==4'b0011)||(ALUctr==4'b0100)||(ALUctr==4'b0110);
    assign OPctr[2]=(ALUctr==4'b0001)||(ALUctr==4'b0010)||(ALUctr==4'b0011)||(ALUctr==4'b0101)||
    (ALUctr==4'b1101)||(ALUctr==4'b1111);
endmodule
