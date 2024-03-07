`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/10 15:49:45
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
   input   wire  pix_clk  ,
   input   wire    [11:0]   pix_x  ,
   input   wire    [11:0]   pix_y  ,
   input   wire  pix_valid,    
   output  wire     [11:0]  pix_data    
    );
    wire [18:0] ram_addr;
wire [11:0] data;
wire i_vaild;
assign i_valid = pix_x >= 320 && pix_x < 960 && pix_y >= 272 && pix_y < 752;
assign ram_addr = i_valid ? (pix_x - 320) + 640 * (pix_y - 272) : 0;
assign pix_data = i_valid & pix_valid ? data : 12'h000;
vga_mem my_pic(.clka(pix_clk),.ena(1'b1),.wea(1'b0),.addra({ram_addr}),.dina(12'd0),.douta(data));
endmodule
