`timescale 1ns / 1ps

module InstrMem(
    output reg [31:0] instr, //输出32位指令
    input [31:0] addr,       //32位地址数据，实际有效字长根据指令存储器容量来确定
    input InstrMemEn,        //指令存储器片选信号
    input clk               //时钟信号，下降沿有效    
 );
   (* ram_style="distributed" *) reg [31:0] ram[16384:0];//64KB的存储器空间，可存储16k条指令，地址有效长度16位
initial $readmemh("./main.hex", ram);
    always @ (posedge clk) begin
       if (InstrMemEn) instr = ram[addr[15:2]];
    end
endmodule
