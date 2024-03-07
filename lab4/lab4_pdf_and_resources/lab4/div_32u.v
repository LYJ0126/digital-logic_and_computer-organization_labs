`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/02 12:05:22
// Design Name: 
// Module Name: div_32u
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


module div_32u(
    output  [31:0] Q,          //商
    output  [31:0] R,          //余数
    output out_valid,        //除法运算结束时，输出为1
    output in_error,         //被除数或除数为0时，输出为1
    input clk,               //时钟 
    input rst,             //复位信号
    input [31:0] X,           //被除数
    input [31:0] Y,           //除数
    input in_valid          //输入为1时，表示数据就绪，开始除法运算
);

// add your code here
 reg [5:0] cn;
 reg [63:0] RDIV;
 reg [31:0] TempQ;
 reg temp_out_valid;
 wire [31:0] diff_result;
 wire cout;
 assign in_error = ((X == 0) || (Y == 0)); //预处理，除数和被除数异常检测报错
 assign out_valid=(in_error||temp_out_valid); //如果检测异常，则结束运算
 always @(posedge clk or posedge rst) begin
 if (rst) cn <= 0; 
 else if (in_valid) cn <= 32;
 else if (cn != 0) cn <= cn - 1;
 end
 // adder32 是 32 位加法器模块的实例化，参见实验 3 的设计
 Adder32 my_adder(.f(diff_result),.cout(cout),.x(RDIV[63:32]),.y(Y),.sub(1'b1),.OF(),.SF(),.ZF(),.CF()); 
 //减法，当 cout=0 时，表示有借位。
 always @(posedge clk or posedge rst) begin
    if (rst) begin RDIV = 0; TempQ=0; end
    else if (in_valid) begin RDIV = {32'b0, X};TempQ=32'b0; temp_out_valid=1'b0;end//0扩展
    else if ((cn >= 0)&&(!out_valid)) begin
        if(cout) begin //判断是否有借位，=1，表示够减，没有借位
            RDIV[63:32] = diff_result[31:0]; //把差值赋值到中间被除数的高 32 位
            TempQ[cn]=1'b1; //商在该位置 1
        end
        if(cn>0) RDIV=RDIV <<1; 
        else temp_out_valid=1'b1;
    end
 end
 assign Q = TempQ;
 assign R =RDIV[63:32];
endmodule
