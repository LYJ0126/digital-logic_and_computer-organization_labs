`timescale 1ns / 1ps


module barrelsft32(
      output [31:0] dout,
      input [31:0] din,
      input [4:0] shamt,     //移动位数
      input LR,           // LR=1时左移，LR=0时右移
      input AL            // AL=1时算术右移，AR=0时逻辑右移
	);
//add your code here
    wire  [31:0] d1,d2,d3,d4;
    assign d1 = (shamt[0]) ? ((LR ) ? ({din[30:0], 1'b0}):((AL) ? {din[31], din[31:1]}:{1'b0, din[31:1]} )) : din;
    assign d2 = (shamt[1]) ? ((LR ) ? ({d1[29:0], 2'b0}):((AL) ? {{2{din[31]}}, d1[31:2]}:{2'b0, d1[31:2]} )) : d1;
    assign d3 = (shamt[2]) ? ((LR ) ? ({d2[27:0], 4'b0}):((AL) ? {{4{din[31]}}, d2[31:4]}:{4'b0, d2[31:4]} )) : d2;
    assign d4 = (shamt[3]) ? ((LR ) ? ({d3[23:0], 8'b0}):((AL) ? {{8{din[31]}}, d3[31:8]}:{8'b0, d3[31:8]} )) : d3;
    assign dout = (shamt[4]) ? ((LR ) ? ({d4[15:0], 16'b0}):((AL) ? {{16{din[31]}}, d4[31:16]}:{16'b0, d4[31:16]} )) : d4;
endmodule
