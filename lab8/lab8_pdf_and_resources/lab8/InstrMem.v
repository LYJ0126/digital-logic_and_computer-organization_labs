`timescale 1ns / 1ps

module InstrMem(
    output reg [31:0] instr, //���32λָ��
    input [31:0] addr,       //32λ��ַ���ݣ�ʵ����Ч�ֳ�����ָ��洢��������ȷ��
    input InstrMemEn,        //ָ��洢��Ƭѡ�ź�
    input clk               //ʱ���źţ��½�����Ч    
 );
   (* ram_style="distributed" *) reg [31:0] ram[16384:0];//64KB�Ĵ洢���ռ䣬�ɴ洢16k��ָ���ַ��Ч����16λ
initial $readmemh("./main.hex", ram);
    always @ (posedge clk) begin
       if (InstrMemEn) instr = ram[addr[15:2]];
    end
endmodule