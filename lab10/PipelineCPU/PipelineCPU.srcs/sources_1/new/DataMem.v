`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/08 16:42:59
// Design Name: 
// Module Name: DataMem
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


module DataMem(
   output [31:0] dataout,   //输出数据
   input clk,                   //时钟信号
   input we,                   //存储器写使能信号，高电平时允许写入数据
   input [2:0] MemOp,          //读写字节数控制
   input [31:0] datain,        //下输入数据
   input [15:0] addr           //存储器地址
    );
    (* ram_style="block" *)  reg [31:0] ram [2**14-1:0];  //设置使用块RAM综合成存储器
//initial $readmemh("./main_d.hex", ram);

wire [31:0] intmp;
wire [31:0] outtmp;
assign outtmp = ram[addr[15:2]];

wire [15:0] houttmp = addr[1] ? outtmp[31:16] : outtmp[15:0];
wire [7:0] bouttmp = addr[1:0] == 2'b11 ? outtmp[31:24]
                   : addr[1:0] == 2'b10 ? outtmp[23:16]
                   : addr[1:0] == 2'b01 ? outtmp[15:8]
                   : outtmp[7:0];


always @(negedge clk)  begin
    if (we) ram[addr[15:2]] <= intmp; //下降沿写入存储器数据，写使能有效时，写入数据
end

assign dataout = MemOp == 3'b000 ? {{24{bouttmp[7]}}, bouttmp}
               : MemOp == 3'b001 ? {{16{houttmp[15]}}, houttmp}
               : MemOp == 3'b010 ? outtmp
               : MemOp == 3'b100 ? {24'h000000, bouttmp}
               : MemOp == 3'b101 ? {16'h0000, houttmp}
               : 32'h00000000;

assign intmp = MemOp == 3'b000 ? 
                    (addr[1:0] == 2'b00 ? {outtmp[31:8], datain[7:0]}
                   : addr[1:0] == 2'b01 ? {outtmp[31:16], datain[7:0], outtmp[7:0]}
                   : addr[1:0] == 2'b10 ? {outtmp[31:24], datain[7:0], outtmp[15:0]}
                   :{datain[7:0], outtmp[23:0]})
             : MemOp == 3'b001 ? 
                    (addr[1] ? {datain[15:0], outtmp[15:0]} : {outtmp[31:16], datain[15:0]})
             : MemOp == 3'b010 ? datain
             : 32'h00000000;
endmodule
