`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 22:03:26
// Design Name: 
// Module Name: ALU32
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


module ALU32(
output  [31:0] result,      //32位运算结果
output  zero,               //结果为0标志位
input   [31:0] dataa,       //32位数据输入，送到ALU端口A   
input   [31:0] datab,       //32位数据输入，送到ALU端口B  
input   [3:0] aluctr        //4位ALU操作控制信号
); 
//add your code here
wire SUBctr,SIGctr,ALctr,SFTctr;
wire [2:0] OPctr;
wire [31:0] muxconnection [6:0];//结果选择mux的输入信号
wire of,sf,cf,mux_less_out;
//由aluctr生成控制信号
ALU_control_signal_generator Acsg(.SUBctr(SUBctr),.SIGctr(SIGctr),
.ALctr(ALctr),.SFTctr(SFTctr),.OPctr(OPctr),.ALUctr(aluctr));
//32位加法器
Adder32forALU my_adder(.f(muxconnection[0]),.sub(SUBctr),.x(dataa),.y(datab^{32{SUBctr}})
,.OF(of),.SF(sf),.CF(cf),.ZF(zero),.cout());
//桶形移位器
barrelsft32 my_barrel(.din(dataa),.dout(muxconnection[4]),.shamt(datab[4:0]),.LR(SFTctr),.AL(ALctr));
assign muxconnection[1]=dataa&datab;
assign muxconnection[2]=dataa|datab;
assign muxconnection[3]=dataa^datab;
assign muxconnection[5]=datab;
mux32b mux_less(.out(mux_less_out),.s(SIGctr),.a(cf),.b(of^sf));
assign muxconnection[6]={31'b0000000000000000000000000000000,mux_less_out};
//结果选择
ALUmux alu_mux(.result(result),.select(OPctr),.in0(muxconnection[0]),.in1(muxconnection[1])
,.in2(muxconnection[2]),.in3(muxconnection[3]),.in4(muxconnection[4]),.in5(muxconnection[5])
,.in6(muxconnection[6]));
endmodule
