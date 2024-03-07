`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 22:03:44
// Design Name: 
// Module Name: ALU32_top
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


module ALU32_top(
output [6:0] segs,           //七段数码管字形输出
output [7:0] AN,            //七段数码管显示32位运算结果 
output  [15:0] result_l,       //32位运算结果
output  zero,             //结果为0标志位
input   [3:0] data_a,           //4位数据输入，重复8次后送到ALU端口A   
input   [3:0] data_b,           //4位数据输入，重复8次后送到ALU端口B  
input   [3:0] aluctr,        //4位ALU操作控制信号
input   clk
); 
//add your code here
wire [31:0] res;
reg [15:0] counter;//数码管刷新计数器
reg [7:0] anout;
reg [6:0] segsout;
wire [6:0] connection [7:0];
assign result_l=res[15:0];
assign segs=segsout;
assign AN=anout;
ALU32 alu(.zero(zero),.dataa({8{data_a}}),.datab({8{data_b}}),.aluctr(aluctr),.result(res));
seg_decode seg_7(.in(res[31:28]),.out(connection[7]));
seg_decode seg_6(.in(res[27:24]),.out(connection[6]));
seg_decode seg_5(.in(res[23:20]),.out(connection[5]));
seg_decode seg_4(.in(res[19:16]),.out(connection[4]));
seg_decode seg_3(.in(res[15:12]),.out(connection[3]));
seg_decode seg_2(.in(res[11:8]),.out(connection[2]));
seg_decode seg_1(.in(res[7:4]),.out(connection[1]));
seg_decode seg_0(.in(res[3:0]),.out(connection[0]));
//数码管显示
always @(posedge clk) begin
    counter<=counter+1;
        case (counter)
            6000: begin
                anout<=8'b01111111;
                segsout<=connection[7];
            end
            12000: begin
                anout<=8'b10111111;
                segsout<=connection[6];
            end
            18000: begin
                anout<=8'b11011111;
                segsout<=connection[5];
            end
            24000: begin
                anout<=8'b11101111;
                segsout<=connection[4];
            end
            30000: begin
                anout<=8'b11110111;
                segsout<=connection[3];
            end
            36000: begin
                anout<=8'b11111011;
                segsout<=connection[2];
            end
            42000: begin
                anout<=8'b11111101;
                segsout<=connection[1];
            end
            48000: begin
                anout<=8'b11111110;
                segsout<=connection[0];
                counter<=0;
            end
        endcase
end
endmodule
