`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 22:02:10
// Design Name: 
// Module Name: Adder32
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


module Adder32(
      output [31:0] f,
      output OF, SF, ZF, CF,
      output cout,
      input [31:0] x, y,
      input sub
	);
//add your code here
    wire c16;
    wire [31:0] y2;
    mux32b mux(.out(y2),.s(sub),.a(y),.b(~y));
    CLA_16 clalow(.f(f[15:0]),.cout(c16),.x(x[15:0]),.y(y2[15:0]),.cin(sub));//低16位计算
    CLA_16 clahigh(.f(f[31:16]),.cout(cout),.x(x[31:16]),.y(y2[31:16]),.cin(c16));//高16位计算
    assign SF=f[31];
    assign CF=cout^sub;
    assign OF=((~x[31])&(~y[31])&f[31])|(x[31]&y[31]&(~f[31]));
    assign ZF=~|f;
endmodule
