`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/30 20:05:59
// Design Name: 
// Module Name: Mode_T
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


module Mode_T(
    input   wire pix_clk,
    input   wire[11:0] pix_x,
    input   wire[11:0] pix_y,
    input   wire  pix_valid,
    output  wire[11:0] pix_data
    );
reg [8 * 80 - 1:0] text[29:0];

integer i;

initial begin
    for (i = 0; i < 30; i = i + 1) begin
        text[i] = 0;
    end
    text[0] = "What the fuck did you just fucking say about me, you little bitch? I'll have you";
    text[1] = "know I graduated top of my class in the Navy Seals, and I've been involved in   ";
    text[2] = "numerous secret raids on Al-Quaeda, and I have over 300 confirmed kills. I am   ";
    text[3] = "trained in gorilla warfare and I'm the top sniper in the entire US armed forces.";
    text[4] = "You are nothing to me but just another target. I will wipe you the fuck out with";
    text[5] = "precision the likes of which has never been seen before on this Earth, mark my  ";
    text[6] = "fucking words. You think you can get away with saying that shit to me over the  ";
    text[7] = "Internet? Think again, fucker. As we speak I am contacting my secret network of ";
    text[8] = "spies across the USA and your IP is being traced right now so you better        ";
    text[9] = "prepare for the storm, maggot. The storm that wipes out the pathetic little     ";
    text[10] = "thing you call your life. You're fucking dead, kid. I can be anywhere, anytime, ";
    text[11] = "and I can kill you in over seven hundred ways, and that's just with my bare     ";
    text[12] = "hands. Not only am I extensively trained in unarmed combat, but I have access to";
    text[13] = "the entire arsenal of the United States Marine Corps and I will use it to its   ";
    text[14] = "full extent to wipe your miserable ass off the face of the continent, you little";
    text[15] = "shit. If only you could have known what unholy retribution your little \"clever\" ";
    text[16] = "comment was about to bring down upon you, maybe you would have held your fucking";
    text[17] = "tongue. But you couldn't, you didn't, and now you're paying the price, you      ";
    text[18] = "goddamn idiot. I will shit fury all over you and you will drown in it. You're   ";
    text[19] = "fucking dead, kiddo.                                                            ";
end

wire [6:0] cha_x;
wire [4:0] cha_y;
wire [2:0] cha_pix_x;
wire [3:0] cha_pix_y;
assign {cha_x, cha_pix_x} = pix_x[9:0];
assign {cha_y, cha_pix_y} = pix_y[8:0];

wire [7:0] cha_ascii;
assign cha_ascii = text[cha_y][(640-8-8*cha_x)+:8];

posasc2bit posasc2bit_inst(
.cha_pix_x(cha_pix_x),
.cha_pix_y(cha_pix_y),
.pix_valid(pix_valid),
.cha_ascii(cha_ascii),
.pix_data(pix_data)
);
endmodule
