`timescale 1ns / 1ps


module VGADraw(
   input   wire            pix_clk  ,
   input   wire    [11:0]   pix_x  ,
    input   wire    [11:0]   pix_y  ,
    input   wire            pix_valid,    
    output  wire     [11:0]  pix_data,
    input wire [7:0] asciiin,
    input [1:0] state
);
    
wire    [18:0] ram_addr;
wire [127:0] asciiout;

reg [27:0] cntdyn;
reg [7:0] temp_r,temp_g,temp_b,temp_d;

always@(posedge pix_clk )begin
    cntdyn<=cntdyn+1;
    temp_d <=cntdyn>>20;
    temp_r<=-pix_x-pix_y-temp_d;
    temp_g<=pix_x-temp_d;
    temp_b<=pix_y-temp_d;
end

assign ram_addr = pix_y * 640 + pix_x;

ASCII asciima(.clk(pix_clk),.addr(asciiin),.outdata(asciiout));

assign pix_data =  (asciiout[127 - ((pix_y%16)*8) - ((pix_x + 7)%8)] == 1'b1)? 12'hfff : 12'b0 ;
endmodule
