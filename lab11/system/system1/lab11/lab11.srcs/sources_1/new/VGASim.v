`timescale 1ns / 1ps

module VGASim(
    input CLK25MHZ,        //系统时钟信号
    input  BTNC,           // 复位信号
    output [3:0] VGA_R,    //红色信号值
    output [3:0] VGA_G,    //绿色信号值
    output [3:0] VGA_B,     //蓝色信号值
    output  VGA_HS,         //行同步信号
    output  VGA_VS,          //帧同步信号
    output wire [11:0] h_addr,
    output wire [11:0] v_addr,
    input [7:0] asciiin
 );
wire [11:0] vga_data;
wire valid;
wire [11:0] H_addr;
wire [11:0] V_addr;
assign h_addr = H_addr;
assign v_addr = V_addr;
//wire CLK25MHZ;
//clk_wiz_0 myvgaclk(.clk_in1(CLK100MHZ),.reset(rst),.locked(locked),.clk_out1(CLK25MHZ));
//divider divider111(.CLK100MHZ(CLK100MHZ),.CLK25MHZ(CLK25MHZ));

VGACtrl vgactrl(.pix_x(H_addr),.pix_y(V_addr),.hsync(VGA_HS),.vsync(VGA_VS),.pix_valid(valid),.pix_clk(CLK25MHZ),.pix_rst(BTNC));
VGADraw vgadraw(.pix_data(vga_data),.pix_x(H_addr),.pix_y(V_addr),.pix_valid(valid),.pix_clk(CLK25MHZ),.asciiin(asciiin));

assign VGA_R=vga_data[11:8];
assign VGA_G=vga_data[7:4];
assign VGA_B=vga_data[3:0];
endmodule
