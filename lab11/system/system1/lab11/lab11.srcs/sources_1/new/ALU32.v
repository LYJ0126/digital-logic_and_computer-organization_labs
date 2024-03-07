`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/24 20:25:29
// Design Name: 
// Module Name: ALU32
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


module ALU32(
output  reg [31:0] result,       //32位运算结果
output  reg zero,             //结果为0标志位
input   [31:0] dataa,          //32位数据输入，送到ALU端口A   
input   [31:0] datab,          //32位数据输入，送到ALU端口B  
input   [3:0] aluctr        //4位ALU操作控制信号
    );
     wire [31:0] f;
wire OF, SF, ZF, CF;
wire cout;
wire sub, sig;

Adder32 my_adder(
.f(f),
.OF(OF),
.SF(SF),
.ZF(ZF),
.CF(CF),
.cout(cout),
.x(dataa),
.y(datab),
.sub(sub)
);

wire [31:0] dout;
wire LR, AL;

barrelsft32 my_barrel(
.dout(dout),
.din(dataa),
.shamt(datab[4:0]),
.LR(LR),
.AL(AL)
);

assign sub = aluctr[1] | aluctr[3];
assign sig = aluctr[0];
assign AL = aluctr[3];
assign LR = ~aluctr[2];

always @(*) begin
    zero = ZF;
    case (aluctr)
        4'b0000: begin
            result = f;
        end
        4'b0001: begin
            result = dout;
        end
        4'b0010: begin
            result = {31'b0, OF ^ SF};
        end
        4'b0011: begin
            result = {31'b0, CF};
        end
        4'b0100: begin
            result = dataa ^ datab;
        end
        4'b0101: begin
            result = dout;
        end
        4'b0110: begin
            result = dataa | datab;
        end
        4'b0111: begin
            result = dataa & datab;
        end
        4'b1000: begin
            result = f;
        end
        4'b1101: begin
            result = dout;
        end
        4'b1111: begin
            result = datab;
        end
        default: result = 32'b0;
    endcase
end
endmodule
