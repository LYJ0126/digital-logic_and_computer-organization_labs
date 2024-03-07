`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2023 08:29:56 PM
// Design Name: 
// Module Name: Display
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


module Display(
    input clk,
    input ctrl_reset,
    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B,
    output VGA_HS,
    output VGA_VS,
    
    input [7:0] ascii,
    input [11:0] color,
    input [7:0] start_line,
    output [12:0] displaymem_addr
);
    wire [11:0] VGA_DATA;
    wire [11:0] vga_data;
    wire VALID;
    wire [4:0] read_addr_v;
    wire [6:0] read_addr_h;
    wire [9:0] H_ADDR;
    wire [9:0] V_ADDR;
    wire [3:0] cnt;
    wire [5:0] r_v_addr;
    assign r_v_addr  = read_addr_v+start_line;//改进
    //assign r_v_addr  = read_addr_v;//改进
    assign displaymem_addr ={read_addr_h,r_v_addr };
    //transfer_ascii mytransfer(ascii,color ,clk,cnt,V_ADDR[3:0],valid,VGA_DATA );
    transfer_ascii mytransfer(ascii,color ,cnt,V_ADDR[3:0],VALID,vga_data );
    VGA_Ctrl myvgactrl(clk,ctrl_reset,VGA_DATA,read_addr_h,read_addr_v,H_ADDR ,V_ADDR ,cnt,VGA_HS,VGA_VS,VALID,VGA_R,VGA_G,VGA_B);
    assign VGA_DATA = (VALID )?vga_data :12'h000; 
endmodule

module transfer_ascii(
    input [7:0] ascii,
    input [11:0] color,
    input [3:0] x,
    input [3:0] y,
    input valid,

    output [11:0] vga_data
);
    reg [11:0] rom[4095:0];
    wire [11:0] addr;
    wire [11:0] font;
    initial
    begin
        $readmemh("F:/testOS/testOS/HardwareCode/fonts_rgb.txt",rom,0,4095);
    end
    assign font = rom[addr];
    assign addr = {ascii[7:0],4'd0} + y;
    assign vga_data = (font[x])  ? ((color==12'd0)?12'hfff:color)  : 12'h000;
endmodule

module VGA_Ctrl(
    input pclk,
    input reset,
    input [11:0] vga_data,
    output reg [6:0] read_addr_h,
    output [4:0] read_addr_v,
    output [9:0] h_addr,
    output [9:0] v_addr,
    output  reg [3:0] cnt,
    output hsync,
    output vsync,
    output valid,
    output [3:0] vga_r,
    output [3:0] vga_g,
    output [3:0] vga_b
);
    parameter h_frontporch = 96;
    parameter h_active = 144;
    parameter h_backporch = 784;
    parameter h_total = 800;
    parameter v_frontporch = 2;
    parameter v_active = 35;
    parameter v_backporch = 515;
    parameter v_total = 525;
    reg [9:0] x_cnt;
    reg [9:0] y_cnt;
    wire h_valid;
    wire v_valid;

    always @(posedge reset or posedge pclk)
    if (reset == 1'b1)
        x_cnt <= 1;
    else
        begin
            if (x_cnt == h_total)
                x_cnt <= 1;
            else
                x_cnt <= x_cnt + 10'd1;
        end

    always @(posedge pclk)
    if (reset == 1'b1)
        y_cnt <= 1;
    else
        begin
            if (y_cnt == v_total & x_cnt == h_total)
                y_cnt <= 1;
            else if (x_cnt == h_total)
                y_cnt <= y_cnt + 10'd1;
        end
    always @(posedge pclk)
    if(!valid)
        begin
            cnt <= 0;
            read_addr_h <= 0;
        end
    else if(h_addr < 630)
        begin
            if(cnt == 8)
                begin
                    cnt <= 0;
                    read_addr_h <= read_addr_h+6'd1;
                end
            else
                cnt <= cnt + 3'd1;
        end
    assign read_addr_v = v_addr[8:4];
    //生成同步信号
    assign hsync = (x_cnt > h_frontporch);
    assign vsync = (y_cnt > v_frontporch);
    //生成消隐信号
    assign h_valid = (x_cnt > h_active) & (x_cnt <= h_backporch);
    assign v_valid = (y_cnt > v_active) & (y_cnt <= v_backporch);
    assign valid = h_valid & v_valid;
    //计算当时有效像素坐标 
    assign h_addr = h_valid ? (x_cnt - 10'd145) : {10{1'b0}};
    assign v_addr = v_valid ? (y_cnt - 10'd36) : {10{1'b0}};
    //设置输出的颜色�??
    assign vga_r = vga_data[11:8];
    assign vga_g = vga_data[7:4];
    assign vga_b = vga_data[3:0];
endmodule
