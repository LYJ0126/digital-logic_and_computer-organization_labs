`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/30 20:05:46
// Design Name: 
// Module Name: Mode_I
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


module Mode_I(
    input   wire           pix_clk  ,
    input   wire    [11:0]   pix_x  ,
    input   wire    [11:0]   pix_y  ,
    input   wire            pix_valid,    
    output  wire     [11:0]  pix_data    
    );
    wire [18:0] ram_addr;
    wire [11:0] tempdata;
assign ram_addr = pix_x + 640 * pix_y;
assign pix_data=(pix_valid==1'b1)?tempdata:12'h000;
vga_mem my_pic(.clka(pix_clk),.ena(1'b1),.wea(1'b0),.addra({ram_addr}),.dina(12'd0),.douta(tempdata));
endmodule
