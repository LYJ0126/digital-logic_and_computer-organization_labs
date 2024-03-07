`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/30 20:29:29
// Design Name: 
// Module Name: VGADraw2
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


module VGADraw2(
    input wire pix_clk,
    input wire[11:0] pix_x,
    input wire[11:0] pix_y,
    input wire pix_valid,
    input wire[7:0] ascii,
    input wire[7:0] cnt,
    output wire[11:0] pix_data
    );
    wire [2:0] mode;
wire [11:0] g_data, i_data, t_data, c_data, x_data;

Mode_X myMode_X_inst(.pix_data(x_data),.pix_x(pix_x),.pix_y(pix_y),.pix_valid(pix_valid),.ascii(ascii),.cnt(cnt),.mode(mode),.pix_clk(pix_clk));
Mode_G myMode_G_inst(.pix_data(g_data),.pix_x(pix_x),.pix_y(pix_y),.pix_valid(pix_valid),.pix_clk(pix_clk));
Mode_I myMode_I_inst(.pix_data(i_data),.pix_x(pix_x),.pix_y(pix_y),.pix_valid(pix_valid),.pix_clk(pix_clk));
Mode_T myMode_T_inst(.pix_data(t_data),.pix_x(pix_x),.pix_y(pix_y),.pix_valid(pix_valid),.pix_clk(pix_clk));

assign pix_data = mode == 0 ? x_data
                : mode == 1 ? g_data
                : mode == 2 ? i_data
                : mode == 3 ? t_data
                : mode == 4 ? x_data
                :             12'h000;
endmodule
