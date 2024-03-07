`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/08 14:44:26
// Design Name: 
// Module Name: InstrParse
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


module InstrParse(
    output [6:0] opcode,     //指令编码7位
    output [4:0] rd,         //目的寄存器编号5位
    output [2:0] funct3,     //3位功能码
    output [4:0] rs1,        //源寄存器1编号5位
    output [4:0] rs2,        //源寄存器2编号5位
    output [6:0] funct7,     //7位功能码
    input [31:0] instr       //指令   
    );
    assign opcode = instr[6:0];
    assign rd = instr[11:7];
    assign funct3 = instr[14:12];
    assign rs1 = instr[19:15];
    assign rs2 = instr[24:20];
    assign funct7 = instr[31:25];
endmodule
