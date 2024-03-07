`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/03 20:26:42
// Design Name: 
// Module Name: Adder32forALU
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


module Adder32forALU(
      output [31:0] f,
      output OF, SF, ZF, CF,
      output cout,
      input [31:0] x, y,
      input sub
    );
    wire c16;
    CLA_16 clalow2(.f(f[15:0]),.cout(c16),.x(x[15:0]),.y(y[15:0]),.cin(sub));//低16位计算
    CLA_16 clahigh2(.f(f[31:16]),.cout(cout),.x(x[31:16]),.y(y[31:16]),.cin(c16));//高16位计算
    assign SF=f[31];
    assign CF=cout^sub;
    assign OF=((~x[31])&(~y[31])&f[31])|(x[31]&y[31]&(~f[31]));
    assign ZF=~|f;
endmodule
