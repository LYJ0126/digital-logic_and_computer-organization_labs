`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/03 22:11:38
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


module seg_decode(
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
            10: out=7'b0001000;
            11: out=7'b0000011;
            12: out=7'b1000110;
            13: out=7'b0100001;
            14: out=7'b0000110;
            15: out=7'b0001110;
            default: out=7'b1000000;
        endcase
endmodule
