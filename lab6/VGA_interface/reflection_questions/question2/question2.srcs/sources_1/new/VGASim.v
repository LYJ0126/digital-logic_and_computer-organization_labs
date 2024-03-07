`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/10 16:52:10
// Design Name: 
// Module Name: VGASim
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


module VGASim(
input CLK100MHZ,        //系统时钟信号
    input  BTNC,           // 复位信号
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

clk_wiz clk_wiz_inst(
.reset(1'b0),
.locked(locked),
.clk_out1(CLK25MHZ),
.clk_in1(CLK100MHZ)
);

VGACtrl vgactrl(.pix_x(h_addr),.pix_y(v_addr),.hsync(VGA_HS),.vsync(VGA_VS),.pix_valid(valid),.pix_clk(CLK25MHZ),.pix_rst(BTNC));
VGADraw vgadraw(.pix_data(vga_data),.pix_x(h_addr),.pix_y(v_addr),.pix_valid(valid),.pix_clk(CLK25MHZ));
assign VGA_R=vga_data[11:8];
assign VGA_G=vga_data[7:4];
assign VGA_B=vga_data[3:0];
endmodule
