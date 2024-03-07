`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/10 16:51:53
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
    reg [8 * 80 - 1:0] text[29:0];

integer i;

initial begin
    for (i = 0; i < 30; i = i + 1) begin
        text[i] = 0;
    end
    text[0] = "    N   N           J       U   U        CCC         SSS                        ";
    text[1] = "    N   N           J       U   U       C   C       S   S                       ";
    text[2] = "    NN  N           J       U   U       C           S                           ";
    text[3] = "    N N N           J       U   U       C            SSS                        ";
    text[4] = "    N  NN           J       U   U       C               S                       ";
    text[5] = "    N   N       J   J       U   U       C   C       S   S                       ";
    text[6] = "    N   N        JJJ         UUU         CCC         SSS                        ";
end

wire [6:0] cha_x;
wire [4:0] cha_y;
wire [2:0] cha_pix_x;
wire [3:0] cha_pix_y;
assign {cha_x, cha_pix_x} = pix_x[9:0];
assign {cha_y, cha_pix_y} = pix_y[8:0];

wire [7:0] cha_ascii;
assign cha_ascii = text[cha_y][(640-8-8*cha_x)+:8];

wire [3:0] para;
assign para = (cha_x + cha_y) % 12;
wire [11:0] color;

assign color = para == 0 ? 12'b000000001111
             : para == 1 ? 12'b000000011110
             : para == 2 ? 12'b000000111100
             : para == 3 ? 12'b000001111000
             : para == 4 ? 12'b000011110000
             : para == 5 ? 12'b000111100000
             : para == 6 ? 12'b001111000000
             : para == 7 ? 12'b011110000000
             : para == 8 ? 12'b111100000000
             : para == 9 ? 12'b111000000001
             : para == 10 ? 12'b110000000011
             : para == 11 ? 12'b100000000111
             : 12'b000000000000;

wire [11:0] data;

posasc2bit posasc2bit_inst(
.cha_pix_x(cha_pix_x),
.cha_pix_y(cha_pix_y),
.pix_valid(pix_valid),
.cha_ascii(cha_ascii),
.pix_data(data)
);

assign pix_data = pix_valid && data != 0 ? color : 0;
endmodule
