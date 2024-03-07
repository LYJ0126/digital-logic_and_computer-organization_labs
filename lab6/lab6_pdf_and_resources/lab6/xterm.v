`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/19 17:02:23
// Design Name: 
// Module Name: xterm
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


module xterm(
    input CLK100MHZ,   //系统时钟信号
    input PS2_CLK,    //来自键盘的时钟信号
    input PS2_DATA,  //来自键盘的串行数据位
    input BTNC,      //Reset
    output [6:0]SEG,
    output [7:0]AN,     //显示扫描码和ASCII码
    output [15:0] LED,   //显示键盘状态
    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B,
    output  VGA_HS,
    output  VGA_VS
);
// Add your code here
wire [7:0] ascii;
wire [7:0] cnt;
wire CLK25MHZ_out, CLK100MHZ_out;
wire locked;

myclk_wiz myclk_wiz_inst(
.reset(1'b0),
.locked(locked),
.clk_out1(CLK100MHZ_out),
.clk_out2(CLK25MHZ_out),
.clk_in1(CLK100MHZ)
);

KeyboardSim KeyboardSim_inst(
.CLK100MHZ(CLK100MHZ_out),
.PS2_CLK(PS2_CLK),
.PS2_DATA(PS2_DATA),
.BTNC(BTNC),
.SEG(SEG),
.AN(AN),
.LED(LED),
.ascii_out(ascii),
.cnt_out(cnt)
);

VGASim2 myVGASim2(
.CLK25MHZ(CLK25MHZ_out),
.BTNC(BTNC),
.ascii(ascii),
.cnt(cnt),
.VGA_R(VGA_R),
.VGA_G(VGA_G),
.VGA_B(VGA_B),
.VGA_HS(VGA_HS),
.VGA_VS(VGA_VS)
);
endmodule

