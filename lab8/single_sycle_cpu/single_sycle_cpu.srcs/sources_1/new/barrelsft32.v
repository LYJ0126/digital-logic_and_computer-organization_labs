`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/27 22:57:24
// Design Name: 
// Module Name: barrelsft32
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


module barrelsft32(
      output [31:0] dout,
      input [31:0] din,
      input [4:0] shamt,     //移动位数
      input LR,           // LR=1时左移，LR=0时右移
      input AL            // AL=1时算数右移，AR=0时逻辑右移
    );
    wire [31:0] al = din << shamt;
	wire [31:0] ar = din >> shamt;
	wire [31:0] lr = $signed(din) >>> shamt;
	assign dout = LR ? al
	            : AL ? lr
	            : ar;
endmodule
