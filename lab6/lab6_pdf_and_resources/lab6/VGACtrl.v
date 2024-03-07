`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/14 23:22:52
// Design Name: 
// Module Name: VGACtrl
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


module VGACtrl(
    input   wire            pix_clk,     //像素时钟信号
    input   wire            pix_rst,     //复位信号
    output  wire  [11:0]    pix_x,      //像素在可显示区域中的水平位置
    output  wire  [11:0]    pix_y,      //像素在可显示区域中的垂直位置
    output  wire            hsync,      //水平同步信号
    output  wire            vsync,      //垂直同步信号
    output wire             pix_valid    //像素在可显示区域标志
);
//hsync1688 	1280×1024@60Hz
   parameter    H_Sync_Width = 112;
   parameter    H_Back_Porche = 248;
   parameter    H_Active_Pixels =1280;
   parameter    H_Front_Porch = 48;
   parameter    H_Totals = 1688;
 //vsync1066
   parameter    V_Sync_Width = 3;
   parameter    V_Back_Porche = 38;
   parameter    V_Active_Pixels =1024;
   parameter    V_Front_Porch = 1;
   parameter    V_Totals = 1066;
   reg [11:0]   cnt_h       ;
   reg [11:0]   cnt_v       ;
   wire         rgb_valid   ;
  //低电平有效   
assign hsync = ((cnt_h >= H_Sync_Width)) ? 1'b0 : 1'b1;  //大于水平同步像素，hsync=0
assign vsync = ((cnt_v >= V_Sync_Width)) ? 1'b0 : 1'b1;  //大于帧同步像素，vsync=0
//cnt_h，cnt_v像素位置计数
always@(posedge pix_clk) begin
         if (pix_rst) begin
            cnt_h <= 0;
            cnt_v <= 0;
        end
       if (cnt_h == (H_Totals-1)) begin               // 行像素结束
            cnt_h <= 0;
            cnt_v <= (cnt_v == (V_Totals-1)) ? 0 : cnt_v + 1;  // 帧像素结束
          end 
        else begin
               cnt_h <= cnt_h + 1;
            end
 end
//pix_valid=1，表示像素处于有效显示区域
assign  pix_valid = (((cnt_h >= H_Sync_Width +H_Back_Porche)
                    && (cnt_h <= H_Totals- H_Front_Porch))
                    &&((cnt_v >= V_Sync_Width +V_Back_Porche)
                    && (cnt_v <= V_Totals - V_Front_Porch)))
                    ? 1'b1 : 1'b0;
//Hsync,Vsync active，计算像素在可显示区域的位置
   assign pix_x = (pix_valid==1) ? (cnt_h - (H_Sync_Width + H_Back_Porche)):12'h0;
   assign pix_y = (pix_valid==1) ? (cnt_v - (V_Sync_Width + V_Back_Porche)):12'h0;
endmodule
