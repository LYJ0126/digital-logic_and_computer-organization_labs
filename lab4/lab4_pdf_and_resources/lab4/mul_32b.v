`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/02 11:14:03
// Design Name: 
// Module Name: mul_32b
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


module mul_32b(
    output [63:0] p,         //乘积
    output out_valid,        //高电平有效时，表示乘法器结束工作
    input clk,              //时钟 
    input rst_n,             //复位信号
    input [31:0] x,           //被乘数
    input [31:0] y,           //乘数
    input in_valid           //高电平有效，表示乘法器开始工作
); 
//add your code here
    reg [5:0] cn; //移位次数寄存器
    always @(posedge clk or posedge rst_n) begin
        if (rst_n) cn <= 0;//复位
        else if (in_valid) cn <= 32;//准备开始工作
        else if (cn != 0) cn <= cn - 1;
    end
    reg [31:0] rx, rp; //加法器操作数和部分积
    reg [32:0] ry;//初始末尾加一位0
    wire [31:0] Adder_result; //加法器运算结果
    wire cout; //进位
 // adder32 是 32 位加法器模块的实例化，参见实验 3 的设计
     Adder32 my_adder(.f(Adder_result),.cout(cout),.x(rp),.y((ry[1:0]==2'b00||ry[1:0]==2'b11)?32'b0:rx),
     .sub((ry[1:0]==2'b10)?1'b1:1'b0),.OF(),.SF(),.ZF(),.CF());
    always @(posedge clk or posedge rst_n) begin
        if (rst_n) {rp, ry, rx} <= 0;
        else if (in_valid) {rp, ry, rx} <= {32'b0, {y,1'b0}, x};
        else if (cn != 0) {rp, ry} <= {Adder_result[31], Adder_result, ry[32:1]};//注意是算术右移
    end
    assign out_valid = (cn == 0);
    assign p = {rp, ry[32:1]};
endmodule
