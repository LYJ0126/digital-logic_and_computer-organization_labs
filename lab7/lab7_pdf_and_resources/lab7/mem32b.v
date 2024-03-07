`timescale 1ns / 1ps

module mem32b(
   output reg [31:0] dataout,   //输出数据
   input clk,                   //时钟信号
   input we,                   //存储器写使能信号，高电平时允许写入数据
   input [2:0] MemOp,          //读写字节数控制信号
   input [31:0] datain,        //输入数据
   input [15:0] addr           //16位存储器地址
);
// Add your code here
reg [3:0] write;
wire [7:0]tempout1;
wire [7:0]tempout2;
wire [7:0]tempout3;
wire [7:0]tempout4;
mem8b mem0(.datain(datain[7:0]),.we(write[0]),.addr(addr),.cs(1),.clk(clk),.dataout(tempout1));
mem8b mem1(.datain(datain[15:8]),.we(write[1]),.addr(addr),.cs(1),.clk(clk),.dataout(tempout2));
mem8b mem2(.datain(datain[23:16]),.we(write[2]),.addr(addr),.cs(1),.clk(clk),.dataout(tempout3));
mem8b mem3(.datain(datain[31:24]),.we(write[3]),.addr(addr),.cs(1),.clk(clk),.dataout(tempout4));

always@(*)begin
    case(MemOp)
        3'b000: begin if(we) begin write = 4'b0001; end else begin write = 0; end dataout = {{24{tempout1[7]}},tempout1};end
        3'b001: begin if(we) begin write = 4'b0011; end else begin write = 0; end dataout = {{16{tempout2[7]}},tempout2,tempout1};end
        3'b010: begin if(we) begin write = 4'b1111; end else begin write = 0; end dataout = {tempout4,tempout3,tempout2,tempout1};end
        3'b100: begin if(we) begin write = 4'b0000; end else begin write = 0; end dataout = {24'b0,tempout1};end
        3'b101: begin if(we) begin write = 4'b0000; end else begin write = 0; end dataout = {16'b0,tempout2,tempout1};end
    endcase
end
endmodule
