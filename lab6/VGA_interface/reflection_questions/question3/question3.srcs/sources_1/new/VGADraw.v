`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/10 17:27:33
// Design Name: 
// Module Name: VGADraw
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


module VGADraw(
input   wire            pix_clk  ,
   input   wire    [11:0]   pix_x  ,
    input   wire    [11:0]   pix_y  ,
    input   wire            pix_valid,    
    output  wire     [11:0]  pix_data    
    );
    wire [5:0] cha_x;
wire [4:0] cha_y;
wire [3:0] cha_pix_x;
wire [3:0] cha_pix_y;
assign {cha_x, cha_pix_x} = pix_x[9:0];
assign {cha_y, cha_pix_y} = pix_y[8:0];

wire [15:0] cha_ascii;
assign cha_ascii = cha_x + 40 * cha_y;

posasc2bit posasc2bit_inst(
.cha_pix_x(cha_pix_x),
.cha_pix_y(cha_pix_y),
.pix_valid(pix_valid),
.cha_ascii(cha_ascii),
.pix_data(pix_data)
);
endmodule
