`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 10:43:24
// Design Name: 
// Module Name: regist7b9
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


module regist7b9(
    output wire [6:0] Out8,//9个7位寄存器的输出
    output wire [6:0] Out7,
    output wire [6:0] Out6,
    output wire [6:0] Out5,
    output wire [6:0] Out4,
    output wire [6:0] Out3,
    output wire [6:0] Out2,
    output wire [6:0] Out1,
    output wire [6:0] Out0,
    input clk, we,init,//时钟信号，写使能，初始化信号
    input [6:0] Initnum8,//初始化输入
    input [6:0] Initnum7,
    input [6:0] Initnum6,
    input [6:0] Initnum5,
    input [6:0] Initnum4,
    input [6:0] Initnum3,
    input [6:0] Initnum2,
    input [6:0] Initnum1,
    input [6:0] Initnum0
    );
    //左移
    register7b re8(.q(Out8),.In(Out7),.Initnum(Initnum8),.clk(clk),.init(init),.we(we));
    register7b re7(.q(Out7),.In(Out6),.Initnum(Initnum7),.clk(clk),.init(init),.we(we));
    register7b re6(.q(Out6),.In(Out5),.Initnum(Initnum6),.clk(clk),.init(init),.we(we));
    register7b re5(.q(Out5),.In(Out4),.Initnum(Initnum5),.clk(clk),.init(init),.we(we));
    register7b re4(.q(Out4),.In(Out3),.Initnum(Initnum4),.clk(clk),.init(init),.we(we));
    register7b re3(.q(Out3),.In(Out2),.Initnum(Initnum3),.clk(clk),.init(init),.we(we));
    register7b re2(.q(Out2),.In(Out1),.Initnum(Initnum2),.clk(clk),.init(init),.we(we));
    register7b re1(.q(Out1),.In(Out0),.Initnum(Initnum1),.clk(clk),.init(init),.we(we));
    register7b re0(.q(Out0),.In(Out8),.Initnum(Initnum0),.clk(clk),.init(init),.we(we));
endmodule
