`timescale 1ns / 1ps

module nextPC(
input reset,
    output [31:0] nxtPC,     //下一个取指令地址，32位，取低16位
    input [31:0] BusA,       //BusA
    input [31:0] curPC,
    input [31:0] Imm,   //PC值、立即数
    input NxtASrc, NxtBSrc   //选择信号，由分支控制部件产生
    );
    wire [31:0] NxtA, NxtB;
    assign NxtA = NxtASrc ? BusA&32'hfffffffe:curPC;//修改过
    assign NxtB = NxtBSrc ? Imm&32'hfffffffe:32'd4;//修改过
    assign nxtPC=(reset) ? curPC : (NxtA+NxtB);
endmodule
