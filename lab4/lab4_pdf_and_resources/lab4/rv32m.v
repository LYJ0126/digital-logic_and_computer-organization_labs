`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/05 10:12:50
// Design Name: 
// Module Name: rv32m
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


module rv32m(
    output  [31:0] rd,        //运算结果
    output out_valid,         //运算结束时，输出为1
    output in_error,          //运算出错时，输出为1
    input clk,               //时钟 
    input rst,               //复位信号，低有效
    input [31:0] rs1,          //操作数rs1
    input [31:0] rs2,          //操作数rs2
    input [2:0] funct3,        //3位功能选择码
    input in_valid           //输入为1时，表示数据就绪，开始除法运算
    );
    //add your code here
    wire [63:0] pu,ps;//无符号，带符号乘积
    wire [31:0] qu,ru,qs,rs;//无符号商与余数；带符号商与余数
    wire [63:0] temppsforhsu;//用于mulhsu指令的特殊中间值
    reg [31:0] result;//结果
    reg [63:0] ansforhsu;//指令mulhsu计算结果
    wire tempout_valid [4:0];
    wire tempin_error [1:0];
    reg finalout_valid;
    reg finalin_error;
    assign rd = result;
    assign out_valid=finalout_valid;
    assign in_error=finalin_error;
    mul_32u rvmul_32u(.p(pu),.out_valid(tempout_valid[0]),.clk(clk),.rst(rst),.x(rs1),.y(rs2),.in_valid(in_valid));
    mul_32b rvmul_32b(.p(ps),.out_valid(tempout_valid[1]),.clk(clk),.rst_n(rst),.x(rs1),.y(rs2),.in_valid(in_valid));
    div_32u rvdiv_32u(.Q(qu),.R(ru),.out_valid(tempout_valid[2]),.in_error(tempin_error[0]),.clk(clk),.rst(rst),.X(rs1),.Y(rs2),.in_valid(in_valid));
    div_32b rvdiv_32b(.Q(qs),.R(rs),.out_valid(tempout_valid[3]),.in_error(tempin_error[1]),.clk(clk),.rst(rst),.X(rs1),.Y(rs2),.in_valid(in_valid));
    mul_32b rvforhsu(.p(temppsforhsu),.out_valid(tempout_valid[4]),.clk(clk),.rst_n(rst),.x(rs1),.y({1'b0,rs2[30:0]}),.in_valid(in_valid));
    always@(*) begin
        case(funct3)
            3'b000: begin
                result=ps[31:0];
                finalout_valid=tempout_valid[1];
                finalin_error=1'b0;
            end
            3'b001: begin
                result=ps[63:32];
                finalout_valid=tempout_valid[1];
                finalin_error=1'b0;
            end
            3'b010: begin
                if(rs2[31]==1'b0)begin
                    ansforhsu=temppsforhsu;
                end
                else begin
                    ansforhsu=temppsforhsu+({rs1[31],rs1,31'b0});
                end
                result=ansforhsu[63:32];
                finalout_valid=tempout_valid[4];
                finalin_error=1'b0;
            end
            3'b011: begin
                result=pu[63:32];
                finalout_valid=tempout_valid[0];
                finalin_error=1'b0;
            end
            3'b100: begin
                result=qs;
                finalout_valid=tempout_valid[3];
                finalin_error=tempin_error[1];
            end
            3'b101: begin
                result=qu;
                finalout_valid=tempout_valid[2];
                finalin_error=tempin_error[0];
            end
            3'b110: begin
                result=rs;
                finalout_valid=tempout_valid[3];
                finalin_error=tempin_error[1];
            end
            3'b111: begin
                result=ru;
                finalout_valid=tempout_valid[2];
                finalin_error=tempin_error[0];
            end
        endcase
    end
endmodule
