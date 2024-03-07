`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2023 06:23:44 PM
// Design Name: 
// Module Name: bcd7seg
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


module bcd7seg(
    input [3:0] datain,
    input [2:0] addr,
    input wrclk,
    input segclk,
    input we,
    output reg [7:0] Hex,
    output reg [7:0] AN
);
    reg [7:0] rom [15:0];
    reg [3:0] seg_data[7:0];
    initial
    begin
        seg_data[0] = 1;
        $readmemh("F:/testOS/testOS/HardwareCode/7seg_table.txt",rom,0,15);
    end
    always @(posedge wrclk)
    begin
        if(we)
            seg_data[addr] <= datain;
    end
    always @(posedge segclk )
    begin
        case(AN )
            8'b00000001:begin AN <= 8'b00000010; Hex <= rom[seg_data[1]]; end
            8'b00000010:begin AN <= 8'b00000100; Hex <= rom[seg_data[2]]; end
            8'b00000100:begin AN <= 8'b00001000; Hex <= rom[seg_data[3]]; end
            8'b00001000:begin AN <= 8'b00010000; Hex <= rom[seg_data[4]]; end
            8'b00010000:begin AN <= 8'b00100000; Hex <= rom[seg_data[5]]; end
            8'b00100000:begin AN <= 8'b01000000; Hex <= rom[seg_data[6]]; end
            8'b01000000:begin AN <= 8'b10000000; Hex <= rom[seg_data[7]]; end
            8'b10000000:begin AN <= 8'b00000001; Hex <= rom[seg_data[0]]; end
            default : AN <= 8'b00000001;
        endcase
    end
   
endmodule
