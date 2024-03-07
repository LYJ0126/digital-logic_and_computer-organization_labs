`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/29 13:59:21
// Design Name: 
// Module Name: mul_32u
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


module mul_32u(
    output [63:0] p, //乘积
    output out_valid, //高电平有效时，表示乘法器结束工作
    input clk, //时钟
    input rst, //复位信号
    input [31:0] x, //被乘数
    input [31:0] y, //乘数
    input in_valid //高电平有效，表示乘法器开始工作
);
//add your code here
    reg [5:0] cn; //移位次数寄存器
    always @(posedge clk or posedge rst) begin
    if (rst) cn <= 0;
    else if (in_valid) cn <= 32;
    else if (cn != 0) cn <= cn - 1;
    end
    reg [31:0] rx, ry, rp; //加法器操作数和部分积
    wire [31:0] Add_result; //加法运算结果
    wire cout; //进位
 // adder32 是 32 位加法器模块的实例化，参见实验 3 的设计
     Adder32 my_adder(.f(Add_result),.cout(cout),.x(rp),.y(ry[0] ? rx : 0),.sub(1'b0),.OF(),.SF(),.ZF(),.CF());
    always @(posedge clk or posedge rst) begin
        if (rst) {rp, ry, rx} <= 0;
        else if (in_valid) {rp, ry, rx} <= {32'b0, y, x};
        else if (cn != 0) {rp, ry} <= {cout, Add_result, ry[31:1]};
    end
    assign out_valid = (cn == 0);
    assign p = {rp, ry};
endmodule

