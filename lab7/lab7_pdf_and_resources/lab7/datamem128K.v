`timescale 1ns / 1ps

module datamem128K #( 
parameter RAM_WIDTH = 32,
parameter RAM_ADDR_WIDTH = 16
)
(
   output reg [31:0] dataout,   //时钟下降沿，并且写入使能为低电平时输出
   input clk,                   //时钟信号
   input we,                   //存储器写使能信号，高电平时允许写入数据
   input [2:0] MemOp,          //读写字节数控制
   input [31:0] datain,        //下降沿写入数据
   input [RAM_ADDR_WIDTH-1:0] addr      //写入地址
//   input [RAM_ADDR_WIDTH-1:0] outaddr   //读取 地址
);
(* ram_style="block" *)  reg [31:0] ram [2**RAM_ADDR_WIDTH-1:0];
reg [31:0] intmp;           //写入数据
reg [31:0] outtmp;           //读取数据
always @(posedge clk)       //上升沿读取存储器数据，先读取地址中数据
begin
       outtmp <= ram[addr[RAM_ADDR_WIDTH-1:2]]; 
end
always @(negedge clk)     //下降沿写入存储器数据，写使能有效时，写入数据
begin
    if (we) begin ram[addr[RAM_ADDR_WIDTH-1:2]] <= intmp; end
end
always @(*)
begin
     if (~we)   //读取操作
        begin
            case (MemOp)
              3'b000: begin dataout = outtmp; end
              3'b001: begin dataout = {24'h000000, outtmp[7:0]}; end
              3'b010: begin dataout = {16'h0000, outtmp[15:0]}; end
              3'b101: begin dataout = {{24{outtmp[7]}}, outtmp[7:0]}; end
              3'b110: begin dataout = {{16{outtmp[15]}}, outtmp[15:0]}; end
              default:dataout = outtmp;
            endcase
        end
        else    //写入操作
        begin
            case (MemOp)
                3'b000: begin intmp = datain; end
                3'b101: begin intmp = {outtmp[31:8], datain[7:0]}; end
                3'b110: begin intmp = {outtmp[31:16], datain[15:0]}; end
               default:intmp = datain;
            endcase
        end
 end
endmodule
