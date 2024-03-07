`timescale 1ns / 1ps


module datamem(
   output reg [31:0] dataout,   //输出数据
   input clk,                   //时钟信号
   input we,                   //存储器写使能信号，高电平时允许写入数据
   input [2:0] MemOp,          //读写字节数控制
   input [31:0] datain,        //下输入数据
   input [15:0] addr           //存储器地址
);
(* ram_style="block" *)  reg [31:0] ram [2**16-1:0];  //设置使用块RAM综合成存储器
reg [31:0] intmp;           
reg [31:0] outtmp;          
always @(posedge clk)   begin
       outtmp <= ram[addr[15:2]]; //上升沿读取存储器数据，先读取地址中数据
end
always @(negedge clk)  begin
    if (we) ram[addr[15:2]] <= intmp; //下降沿写入存储器数据，写使能有效时，写入数据
end
always @(*)
begin
   if (~we)  begin  //读取操作
            case (MemOp)
              3'b000: begin dataout = outtmp; end
              3'b001: begin dataout = {24'h000000, outtmp[7:0]}; end
              3'b010: begin dataout = {16'h0000, outtmp[15:0]}; end
              3'b101: begin dataout = {{24{outtmp[7]}}, outtmp[7:0]}; end
              3'b110: begin dataout = {{16{outtmp[15]}}, outtmp[15:0]}; end
              default:dataout = outtmp;
            endcase
        end
    else  begin  //写入操作
            case (MemOp)
                3'b000: begin intmp = datain; end
                3'b101: begin intmp = {outtmp[31:8], datain[7:0]}; end
                3'b110: begin intmp = {outtmp[31:16], datain[15:0]}; end
               default:intmp = datain;
            endcase
        end
 end
endmodule
