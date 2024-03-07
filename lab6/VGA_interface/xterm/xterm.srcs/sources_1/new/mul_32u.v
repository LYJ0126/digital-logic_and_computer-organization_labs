`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/30 20:42:23
// Design Name: 
// Module Name: mul_32u
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


module mul_32u(
     input clk, rst,
     input [31:0] x, y,
     input in_valid,
     output [63:0] p,
     output out_valid
    );
    reg [5:0] cn; //移位次数寄存器
    always @(posedge clk or posedge rst) begin
        if (rst) cn <= 0;
        else if (in_valid) cn <= 32;
        else if (cn != 0) cn <= cn - 1;
    end
    reg [31:0] rx, ry, rp; //加法器操作数和部分积
    wire [31:0] Add_result; //加法运算结果
    wire cout; //进位
    // adder32 是 32 位加法器模块的实例化，参见实验 3 的设计
    Adder32 my_adder(.f(Add_result),.cout(cout),.x(rp),.y(ry[0] ? rx : 0),.sub(0));
    always @(posedge clk or posedge rst) begin
        if (rst) {rp, ry, rx} <= 0;
        else if (in_valid) {rp, ry, rx} <= {32'b0, y, x};
        else if (cn != 0) {rp, ry} <= {cout, Add_result, ry} >> 1;
    end
    assign out_valid = (cn == 0);
    assign p = {rp, ry};
endmodule
