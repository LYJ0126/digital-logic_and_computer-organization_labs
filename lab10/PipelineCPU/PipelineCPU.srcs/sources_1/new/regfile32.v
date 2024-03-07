`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/08 14:48:13
// Design Name: 
// Module Name: regfile32
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


module regfile32(
    input reset,
    input [31:0] a0,//后面进行累加求和时，这个是入参保存寄存器
	output wire [31:0] busa,   //寄存器ra输出数据
	output wire [31:0] busb,   //寄存器rb输出数据
	input clk,
	input [4:0] ra,           //读寄存器编号ra
	input [4:0] rb,          //读寄存器编号rb
	input [4:0] rw,          //写寄存器编号rw
	input [31:0] busw,       //写入数据端口
	input we	             //写使能端，为1时，可写入
    );
    (* ram_style="registers" *) reg [31:0] regfiles[31:0];
  	initial
	begin
		regfiles[0]=32'b0;
	end
	assign busa=regfiles[ra]; //读端口ra
	assign busb=regfiles[rb];//读端口rb
	integer i;
	always@(posedge clk or posedge reset)
	begin
	   if(reset) begin
	       for(i = 0; i <= 31; i = i + 1)
	       begin 
	           if(i == 2)begin
	               regfiles[i] <= 32'h100;
	           end
	           else if(i == 10)begin
	               regfiles[i] <= a0;
	           end
	           else begin
	               regfiles[i] <= 0;
	               end 
	       end
	   end
	   else if(we==1'b1) regfiles[rw] <= (rw==5'b00000)? 32'b0:busw; //写端口
	end
endmodule
