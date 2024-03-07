`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/09 20:16:00
// Design Name: 
// Module Name: trans4to4_tb
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


module trans4to4_tb(    );
   wire [2:0] Y0,Y1,Y2,Y3;
   reg [2:0] D0,D1,D2,D3; // 输入变量声明为 reg 型变量
   reg [1:0] S;         // 输入变量声明为 reg 型变量
   trans4to4 uut (.Y0(Y0),.Y1(Y1),.Y2(Y2),.Y3(Y3),.S(S),.D0(D0),.D1(D1),.D2(D2),.D3(D3) );
   initial
   begin
   D0=$random % 8;D1=$random % 8;D2=$random % 8;D3=$random % 8;
   // D0=2'b00;D1=2'b01;D2=2'b10;D3=2'b11;
       S=2'b00;
   #50 S=2'b01;
   #50 S=2'b10;
   #50 S=2'b11;
   #50 S=2'b00;
   $stop;
   end

endmodule
