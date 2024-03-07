`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2022 02:40:49 PM
// Design Name: 
// Module Name: regfile
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


module ctrgen(
    input [6:0] op,
    input [2:0] func3,
    input [6:0] func7,

    output reg [2:0] ExtOP,
    output reg RegWr,
    output reg ALUAsrc, //0:rs1,1:PC
    output reg [1:0] ALUBsrc, //00:rs1,01:rs2,01:imm,11:4
    output reg [3:0] ALUctr,
    output reg [2:0] Branch,
    output reg MemtoReg,
    output reg MemWr,
    output reg [2:0] MemOP //为 010 时为 4 字节读写，为 001 时为 2 字节读写带符号扩展，为 000 时为 1 字节读写带符号扩展，为 101 时为 2 字节读写无符号扩展，为 100 时为 1 字节读写无符号扩展。
);
    always @(*)
    begin
        casex(op[6:2])
            5'b01101: begin
                ExtOP = 3'b001;
                RegWr = 1'b1;
                Branch = 3'b000;
                MemtoReg = 1'b0;
                MemWr = 1'b0;
                ALUBsrc = 2'b01;
                ALUctr = 4'b0011;
            end
            5'b00101: begin
                ExtOP = 3'b001;
                RegWr = 1'b1;
                Branch = 3'b000;
                MemtoReg = 1'b0;
                MemWr = 1'b0;
                ALUAsrc = 1'b1;
                ALUBsrc = 2'b01;
                ALUctr = 4'b0000;
            end
            5'b00100: begin
                ExtOP = 3'b000;
                RegWr = 1'b1;
                Branch = 3'b000;
                MemtoReg = 1'b0;
                MemWr = 1'b0;
                ALUAsrc = 1'b0;
                ALUBsrc = 2'b01;
                case (func3)
                    3'b000: ALUctr = 4'b0000;
                    3'b010: ALUctr = 4'b0010;
                    3'b011: ALUctr = 4'b1010;
                    3'b100: ALUctr = 4'b0100;
                    3'b110: ALUctr = 4'b0110;
                    3'b111: ALUctr = 4'b0111;
                    3'b001: if(~func7[5]) ALUctr  = 4'b0001;
                    3'b101: ALUctr  = func7[5] ? 4'b1101:4'b0101;
                endcase
            end
            5'b01100: begin
                RegWr = 1'b1;
                Branch = 3'b000;
                MemtoReg = 1'b0;
                MemWr = 1'b0;
                ALUAsrc = 1'b0;
                ALUBsrc = 2'b00;
                case (func3)
                    3'b000: ALUctr = func7[5]? 4'b1000:4'b0000;
                    3'b001: if(~func7[5]) ALUctr  = 4'b0001;
                    3'b010: if(~func7[5]) ALUctr  = 4'b0010;
                    3'b011: if(~func7[5]) ALUctr  = 4'b1010;
                    3'b100: if(~func7[5]) ALUctr  = 4'b0100;
                    3'b101: ALUctr = func7[5]? 4'b1101:4'b0101;
                    3'b110: if(~func7[5]) ALUctr  = 4'b0110;
                    3'b111: if(~func7[5]) ALUctr  = 4'b0111;
                endcase
            end
            5'b11011: begin
                ExtOP = 3'b100;
                RegWr = 1'b1;
                Branch = 3'b001;
                MemtoReg = 1'b0;
                MemWr = 1'b0;
                ALUAsrc = 1'b1;
                ALUBsrc = 2'b10;
                ALUctr = 4'b0000;
            end
            5'b11001: begin
                ExtOP = 3'b000;
                RegWr = 1'b1;
                Branch = 3'b010;
                MemtoReg = 1'b0;
                MemWr = 1'b0;
                ALUAsrc = 1'b1;
                ALUBsrc = 2'b10;
                if(func3==3'b000) ALUctr = 4'b0000;
            end
            5'b11000: begin
                ExtOP = 3'b011;
                RegWr = 1'b0;
                MemWr = 1'b0;
                ALUAsrc = 1'b0;
                ALUBsrc = 2'b00;
                case (func3)
                    3'b000: begin Branch = 3'b100; ALUctr = 4'b0010; end
                    3'b001: begin Branch = 3'b101; ALUctr = 4'b0010; end
                    3'b100: begin Branch = 3'b110; ALUctr = 4'b0010; end
                    3'b101: begin Branch = 3'b111; ALUctr = 4'b0010; end
                    3'b110: begin Branch = 3'b110; ALUctr = 4'b1010; end
                    3'b111: begin Branch = 3'b111; ALUctr = 4'b1010; end
                endcase
            end
            5'b00000: begin
                ExtOP = 3'b000;
                RegWr = 1'b1;
                Branch = 3'b000;
                MemtoReg = 1'b1;
                MemWr = 1'b0;
                MemOP = func3;
                ALUAsrc = 1'b0;
                ALUBsrc = 2'b01;
                ALUctr = 4'b0000;
            end
            5'b01000: begin
                ExtOP = 3'b010;
                RegWr = 1'b0;
                Branch = 3'b000;
                MemWr = 1'b1;
                MemOP = func3;
                ALUAsrc = 1'b0;
                ALUBsrc = 2'b01;
                ALUctr = 4'b0000;
            end
        endcase
    end

endmodule
