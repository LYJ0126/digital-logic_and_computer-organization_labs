`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/05 10:13:11
// Design Name: 
// Module Name: rv32m_top
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


module rv32m_top(
    output  [15:0] rd_l,        //运算结果的低16位
    output out_valid,         //运算结束时，输出为1
    output in_error,          //运算出错时，输出为1
    output [6:0] segs,        // 7段数值
    output [7:0] AN,         //数码管选择
    input clk,               //时钟 
    input rst,               //复位信号，低有效
    input [3:0] x,           //操作数1，重复8次后作为rs1
    input [3:0] y,           //操作数2，重复8次后作为rs2
    input [2:0] funct3,        //3位功能选择码
    input in_valid          //输入为1时，表示数据就绪，开始运算
    );
    //add your code here
    wire [31:0]rd;
    assign rd_l=rd[15:0];
    rv32m myrv32m(.rd(rd),.out_valid(out_valid),.in_error(in_error),.clk(clk),.rst(rst),.rs1({8{x}}),
    .rs2({8{y}}),.funct3(funct3),.in_valid(in_valid));
    reg [15:0] counter;//数码管刷新计数器
    reg [7:0] anout;
    reg [6:0] segsout;
    wire [6:0] connection [7:0];
    assign segs=segsout;
    assign AN=anout;
    seg_decode seg_7(.in(rd[31:28]),.out(connection[7]));
    seg_decode seg_6(.in(rd[27:24]),.out(connection[6]));
    seg_decode seg_5(.in(rd[23:20]),.out(connection[5]));
    seg_decode seg_4(.in(rd[19:16]),.out(connection[4]));
    seg_decode seg_3(.in(rd[15:12]),.out(connection[3]));
    seg_decode seg_2(.in(rd[11:8]),.out(connection[2]));
    seg_decode seg_1(.in(rd[7:4]),.out(connection[1]));
    seg_decode seg_0(.in(rd[3:0]),.out(connection[0]));
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
