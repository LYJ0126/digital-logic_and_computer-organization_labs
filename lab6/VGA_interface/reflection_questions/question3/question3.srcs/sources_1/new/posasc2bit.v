`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/10 17:30:03
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
 input   wire    [3:0]  cha_pix_x,
    input   wire    [3:0]  cha_pix_y,
    input   wire    [15:0]  cha_ascii,
    input   wire           pix_valid,
    output  wire    [11:0] pix_data
    );
    reg [255:0] ascii_mem[33143:0];

initial begin
    $readmemh("C:/Vivadolabs/lab6/VGA_interface/reflection_questions/question3/HZK16S.txt", ascii_mem, 0, 33143);
end

wire [255:0] cha_font;
assign cha_font = ascii_mem[cha_ascii];
assign pix_data = cha_font[-cha_pix_x - 16 * cha_pix_y - 1] && pix_valid ? 12'hfff : 12'h000;

endmodule
