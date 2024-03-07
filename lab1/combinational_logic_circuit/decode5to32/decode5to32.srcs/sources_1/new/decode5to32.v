`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/16 20:18:10
// Design Name: 
// Module Name: decode5to32
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


module decode5to32(//5-32ÒëÂëÆ÷
    output reg [31:0] Out,
    input [4:0] In,
    input En
    );
    always@(In,En)
        begin
            Out = 32'b00000000000000000000000000000000;
            if(En==1) Out[In] = 1;
        end
endmodule
