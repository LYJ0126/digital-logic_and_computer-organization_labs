`timescale 1ns / 1ps

module regfile32(
input reset,
	output wire [31:0] busa,   //寄存器ra输出数据
	output wire [31:0] busb,   //寄存器rb输出数据
	input clk,
	input [4:0] ra,           //读寄存器编号ra
	input [4:0] rb,          //读寄存器编号rb
	input [4:0] rw,          //写寄存器编号rw
	input [31:0] busw,       //写入数据端口
	input we	             //写使能端，为1时，可写入
	);
  (* ram_style="registers" *) reg [31:0] regfiles[31:0];      //综合时使用寄存器实现寄存器堆
  	initial
	begin
		regfiles[0]=32'b0;
	end
	assign busa=regfiles[ra]; ////读端口ra
	assign busb=regfiles[rb];
	integer i;
	always@(posedge clk or posedge reset)
	begin
	   if(reset) begin
	       for(i = 0; i <= 31; i = i + 1)
	       begin 
	               regfiles[i] <= 0;
	       end
	   end
	   else if(we==1'b1) regfiles[rw] <= (rw==5'b00000)? 32'b0:busw; //写端口
	end
	
endmodule
