`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/16 20:17:44
// Design Name: 
// Module Name: regfile32
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
module regfile32(
/*RA 和 RB 分别是读口 1和读口 2 的寄存器编号，RW 是写口的寄存器编号。寄存器堆的读操作属于组合逻辑操作，
无须时钟控制，即当寄存器地址信号 RA 或 RB 到达后，经过一个"读取时间"的延迟，读出的信息在 busA 或 busB 
上开始有效。寄存器堆的写操作属于时序逻辑操作，需要时钟信号的控制；即在写使能信号（WE）有效的情况下，
下个时钟触发边沿到来时开始将 busW 上的信息写入 RW 所指定的寄存器中。*/
//写使能信号 we 高电平有效，写入时钟 clk 下降沿有效，0 号寄存器的值始终为 0
   output  [31:0] busa,
   output  [31:0] busb,
   input [31:0] busw,
   input [4:0] ra,
   input [4:0] rb,
   input [4:0] rw,
   input clk, we
);
// add your code 
// 32个32位寄存器
  reg [31:0] registers [31:0];
  // 写操作
  always @(negedge clk)
    begin
      if (we==1&&rw!=5'b00000)
        registers[rw] <= busw;
    end
      // 读操作
      assign busa = (ra==5'b00000)?8'h00000000:registers[ra];
      assign busb = (rb==5'b00000)?8'h00000000:registers[rb];
endmodule

