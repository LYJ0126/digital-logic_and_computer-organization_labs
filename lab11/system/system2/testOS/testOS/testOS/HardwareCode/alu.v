`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2022 02:48:14 PM
// Design Name: 
// Module Name: alu
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

module alu(
    input [31:0] dataa,
    input [31:0] datab,
    input [3:0]  ALUctr,
    output reg less,
    output zero,
    output reg [31:0] aluresult
);

    assign zero = ALUctr[2:0] == 3'b010 ? dataa == datab : aluresult == 0;
    always@*
    casex(ALUctr)
        4'b0000: aluresult = dataa + datab;
        4'b1000: aluresult = dataa - datab;
        4'b?001: aluresult = dataa << datab[4:0];
        4'b0010: begin less = $signed(dataa) < $signed(datab); aluresult = less; end
        4'b1010: begin less = dataa < datab; aluresult = less; end
        4'b?011: aluresult = datab;
        4'b?100: aluresult = dataa ^ datab;
        4'b0101: aluresult = dataa >> datab[4:0];
        4'b1101: aluresult = ($signed(dataa)) >>> datab[4:0];
        4'b?110: aluresult = dataa | datab;
        4'b?111: aluresult = dataa & datab;
    endcase
endmodule
