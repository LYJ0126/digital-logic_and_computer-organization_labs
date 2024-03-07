`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/26 01:17:57
// Design Name: 
// Module Name: seg_decode
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


module seg_decode(//BCD码转数码管段输入信号
    input [3:0] in,
    output reg [6:0] out
    );
    always @(*)
        case (in)
            0: out=7'b1000000;
            1: out=7'b1111001;
            2: out=7'b0100100;
            3: out=7'b0110000;
            4: out=7'b0011001;
            5: out=7'b0010010;
            6: out=7'b0000010;
            7: out=7'b1111000;
            8: out=7'b0000000;
            9: out=7'b0010000;
            default: out=7'b1000000;
        endcase
endmodule
