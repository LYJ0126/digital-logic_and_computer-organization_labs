`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2022 04:13:09 PM
// Design Name: 
// Module Name: rv32is
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


module rv32is(
    input 	clock,
    input 	reset,
    output [31:0] imemaddr,
    input  [31:0] imemdataout,
    output 	imemclk,
    output [31:0] dmemaddr,
    input  [31:0] dmemdataout,
    output [31:0] dmemdatain,
    output 	dmemrdclk,
    output	dmemwrclk,
    output [2:0] dmemop,
    output	dmemwe);
    //output [31:0] dbgdata);
    //add your code here
    //clock
    assign imemclk = ~clock;
    assign dmemrdclk = clock;
    assign dmemwrclk = ~clock;
    //decode
    wire [31:0] instr;
    wire [6:0] op;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire [2:0] func3;
    wire [6:0] func7;
    assign instr = imemdataout;
    decode mydecoder(instr,op,rs1,rs2,rd,func3,func7);
    
    //Control Signal Generator
    wire  [2:0] ExtOP;
    wire  RegWr;
    wire  ALUAsrc; //0:rs1,1:PC
    wire  [1:0] ALUBsrc; //00:rs1,01:rs2,01:imm,11:4
    wire  [3:0] ALUctr;
    wire  [2:0] Branch;
    wire  MemtoReg;
    wire  MemWr;
    wire  [2:0] MemOP ; //为 010 时为 4 字节读写，为 001 时为 2 字节读写带符号扩展，为 000 时为 1 字节读写带符号扩展，为 101 时为 2 字节读写无符号扩展，为 100 时为 1 字节读写无符号扩展。
    ctrgen myctrgen(op ,func3 ,func7 ,ExtOP ,RegWr ,ALUAsrc ,ALUBsrc ,ALUctr ,Branch ,MemtoReg ,MemWr ,MemOP );
    
    //regfile
    wire [4:0] Ra;
    wire [4:0] Rb;
    wire [4:0] Rw;
    wire [31:0] busW;
    wire  WrClk;
    wire [31:0] busA;
    wire [31:0] busB;
    assign WrClk = ~clock;
    assign Ra = rs1;
    assign Rb = rs2;
    assign Rw = rd;
    regfile myregfile(Ra,Rb,Rw,busW,RegWr,WrClk,busA,busB);
    
    //immediate number generator
    wire [31:0] imm;
    immgen myimmgen(instr,ExtOP,imm);
    
    //ALU
    wire [31:0] dataa;
    wire [31:0] datab;
    assign dataa = ALUAsrc ? PC : busA ;
    assign datab = (ALUBsrc[1] ? (ALUBsrc[0]? 0 : 4): (ALUBsrc[0]? imm : busB));
    
    wire less;
    wire zero;
    wire [31:0] aluresult;
    alu myalu(dataa ,datab ,ALUctr ,less ,zero ,aluresult );
    
    //Branch control
    wire PCASrc;
    wire PCBSrc;
    branchctr mybranchctr(Branch ,zero ,less ,PCASrc ,PCBSrc );
    
    //PC generator
    reg [31:0] PC = 0;
    //assign dbgdata = PC;
    assign imemaddr = NEXTPC;
    wire [31:0] NEXTPC;
    pcgen mypcgen(PC,imm,busA,PCASrc ,PCBSrc , reset , NEXTPC );
    always@(negedge clock )
       PC <= NEXTPC ;
    
    //mem
    assign dmemop = MemOP;
    assign dmemwe = MemWr;
    assign dmemaddr = aluresult;
    assign dmemdatain = busB;
    assign busW = MemtoReg ? dmemdataout : aluresult;
    
endmodule
