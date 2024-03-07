`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/30 20:01:23
// Design Name: 
// Module Name: VGASim2
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


module VGASim2(
    input CLK25MHZ,
    input  BTNC,           // 复位信号
    input  [7:0] ascii,
    input  [7:0] cnt,
    output [3:0] VGA_R,    //红色信号值
    output [3:0] VGA_G,    //绿色信号值
    output [3:0] VGA_B,     //蓝色信号值
    output  VGA_HS,         //行同步信号
    output  VGA_VS          //帧同步信号
    );
    wire [11:0] vga_data;
    wire valid;
    wire [11:0] h_addr;
    wire [11:0] v_addr;

    VGACtrl2 vgactrl(.pix_x(h_addr),.pix_y(v_addr),.hsync(VGA_HS),.vsync(VGA_VS),.pix_valid(valid),.pix_clk(CLK25MHZ),.pix_rst(BTNC));
    VGADraw2 vgadraw(.pix_clk(CLK25MHZ),.pix_x(h_addr),.pix_y(v_addr),.pix_valid(valid),.ascii(ascii),.cnt(cnt),.pix_data(vga_data));

    assign VGA_R=vga_data[11:8];
    assign VGA_G=vga_data[7:4];
    assign VGA_B=vga_data[3:0];
endmodule
