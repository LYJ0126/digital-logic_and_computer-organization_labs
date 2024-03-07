`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 16:33:34
// Design Name: 
// Module Name: encryption6b
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


module encryption6b(
    output [7:0] dataout,    //输出加密或解密后的8比特ASCII数据。
    output reg ready,       //输出有效标识，高电平说明输出有效，第6周期高电平
    output [5:0] key,       //输出6位加密码
    input clk,             // 时钟信号，上升沿有效
    input load,            //载入seed指示，高电平有效
    input [7:0] datain       //输入数据的8比特ASCII码。
);
wire  [63:0] seed=64'ha845fd7183ad75c4;       //初始64比特seed=64'ha845fd7183ad75c4
//add your code here
    wire [63:0] lfsrout;
    reg [5:0] count;
    reg [5:0] keyout;
    reg [7:0] ddout;
    assign key=keyout;
    assign dataout=ddout;
    lfsr yiwei(.dout(lfsrout),.seed(seed),.clk(clk),.load(load));
    always @(posedge clk) begin
        if(load) begin
            count<=0;
            ready<=0;
        end
        else begin
            if(count==5)begin
                ready<=1;
                count<=0;//清零
            end
            else begin
                count<=count+1;
            end
            if(ready==1) begin
                keyout<=lfsrout[63:58];
                ddout<={datain[7:6],datain[5:0]^lfsrout[63:58]};
                ready<=0;
            end
        end
    end
endmodule

module lfsr(              //64位线性移位寄存器
	output reg [63:0] dout,
    input  [63:0]  seed,
	input  clk,
	input  load
	);
//add your code here
    wire next;
    assign next=dout[4]^dout[3]^dout[1]^dout[0]; // LFSR feedback equation: x64 = x4 ^ x3 ^ x1 ^ x0
    always @(posedge clk or posedge load) begin
        if (load) begin
            dout <= seed;
        end
        else begin
            dout<={next,dout[63:1]};
        end
    end
endmodule
