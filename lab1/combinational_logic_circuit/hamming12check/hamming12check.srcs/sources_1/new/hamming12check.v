`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/20 16:47:18
// Design Name: 
// Module Name: hamming12check
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


module hamming12check(
   output reg [12:1] DC,    //纠错输出12位正确的结果
   output reg  NOERROR,    //校验结果正确标志位
   input  [12:1] DU         //输入12位汉明码
    );
    wire [15:1] connection;
    assign connection={3'b000,DU};//高3位为000
    wire odd1,odd2,odd3,odd4;
    wire e0,e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15;
    paritycheck8b pcheck1(.In({connection[1],connection[3],connection[5],connection[7],connection[9]
    ,connection[11],connection[13],connection[15]}),.odd(odd1),.even());
    paritycheck8b pcheck2(.In({connection[2],connection[3],connection[6],connection[7],connection[10]
    ,connection[11],connection[14],connection[15]}),.odd(odd2),.even());
    paritycheck8b pcheck3(.In({connection[4],connection[5],connection[6],connection[7],connection[12]
    ,connection[13],connection[14],connection[15]}),.odd(odd3),.even());
    paritycheck8b pcheck4(.In(connection[15:8]),.odd(odd4),.even());
    decode4to16 dec(.In({odd4,odd3,odd2,odd1}),.En(1),
    .Out({e15,e14,e13,e12,e11,e10,e9,e8,e7,e6,e5,e4,e3,e2,e1,e0}));
    always@(*)begin
        NOERROR=e0;
        DC[1]=e1^DU[1];
        DC[2]=e2^DU[2];
        DC[3]=e3^DU[3];
        DC[4]=e4^DU[4];
        DC[5]=e5^DU[5];
        DC[6]=e6^DU[6];
        DC[7]=e7^DU[7];
        DC[8]=e8^DU[8];
        DC[9]=e9^DU[9];
        DC[10]=e10^DU[10];
        DC[11]=e11^DU[11];
        DC[12]=e12^DU[12];
    end
endmodule
