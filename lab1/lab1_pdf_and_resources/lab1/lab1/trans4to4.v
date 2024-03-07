`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/09 20:14:55
// Design Name: 
// Module Name: trans4to4
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


module trans4to4(
    output  [2:0] Y0,Y1,Y2,Y3,
    input   [2:0] D0,D1,D2,D3,
    input   [1:0] S
); 
// add your code here
    wire [2:0] connection;
    mux4to1 mux(.y(connection),.s(S),.d0(D0),.d1(D1),.d2(D2),.d3(D3));
    dmux1to4 dmux(.d0(Y0),.d1(Y1),.d2(Y2),.d3(Y3),.d(connection),.s(S));
endmodule
