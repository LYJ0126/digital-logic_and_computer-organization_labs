`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/10 17:14:12
// Design Name: 
// Module Name: posasc2bit
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


module posasc2bit(
 input   wire    [2:0]  cha_pix_x,
    input   wire    [3:0]  cha_pix_y,
    input   wire    [7:0]  cha_ascii,
    input   wire           pix_valid,
    output  wire    [11:0] pix_data
    );
    reg [127:0] ascii_mem[255:0];

initial begin
    $readmemh("C:/Vivadolabs/lab6/lab6_pdf_and_resources/lab6/ASC16.txt", ascii_mem, 0, 255);
end

wire [127:0] cha_font;
assign cha_font = ascii_mem[cha_ascii];
assign pix_data = cha_font[-cha_pix_x - 8 * cha_pix_y - 1] && pix_valid ? 12'hfff : 12'h000;
endmodule
