`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/20 16:45:06
// Design Name: 
// Module Name: paritycheck8b
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


module paritycheck8b(
    output odd, // 奇校验位
    output even, // 偶校验位
    input wire [7:0] In // 输入数据
    );
    assign odd=In[0]^In[1]^In[2]^In[3]^In[4]^In[5]^In[6]^In[7];
    assign even=~odd;
endmodule
