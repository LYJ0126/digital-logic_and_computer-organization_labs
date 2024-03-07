`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/14 23:25:20
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
    
wire    [18:0] ram_addr;
vga_mem my_pic(.clka(pix_clk),.ena(1'b1),.wea(1'b0),.addra({ram_addr}),.dina(12'd0),.douta(pix_data));
assign ram_addr=pix_x+pix_y*640;
//reg [27:0] cntdyn;
// [7:0] temp_r,temp_g,temp_b,temp_d;

/*always@(posedge pix_clk )begin
    cntdyn<=cntdyn+1;
    temp_d <=cntdyn>>20;
    temp_r<=-pix_x-pix_y-temp_d;
    temp_g<=pix_x-temp_d;
    temp_b<=pix_y-temp_d;
end
assign  pix_data[11:8]=temp_r[7:4];
assign  pix_data[7:4]=temp_g[7:4];
assign  pix_data[3:0]=temp_b[7:4];*/
  
endmodule
