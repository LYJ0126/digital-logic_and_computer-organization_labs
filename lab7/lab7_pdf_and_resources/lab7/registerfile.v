`timescale 1ns / 1ps


module registerfile(
	output wire [31:0] busa,   //寄存器ra输出数据
	output wire [31:0] busb,   //寄存器rb输出数据
	input clk,
	input [4:0] ra,           //读寄存器编号ra
	input [4:0] rb,          //读寄存器编号rb
	input [4:0] rw,          //写寄存器编号rw
	input [31:0] busw,       //写入数据端口
	input we	             //写使能端，为1时，可写入
	);
  (* ram_style="registers" *) reg [31:0] regfiles[0:31];      //综合时使用寄存器实现寄存器堆
	always @(posedge clk)  begin      
		if((we==1'b1))	 regfiles[rw]<=busw;             //写端口
	 end
    assign 	busa=(ra==5'b0) ? 32'b0 : regfiles[ra];     //读端口ra
    assign 	busb=(rb==5'b0) ? 32'b0 : regfiles[rb];     //读端口rb
endmodule
