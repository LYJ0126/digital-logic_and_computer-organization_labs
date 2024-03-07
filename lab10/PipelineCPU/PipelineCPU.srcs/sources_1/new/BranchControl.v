`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/08 15:16:21
// Design Name: 
// Module Name: BranchControl
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


module BranchControl(
    output reg Branchsel, PCsel,
    output flushIF, flushID,
    input zero, result0,
    input [2:0] Branch
    );
    assign flushIF = PCsel;
    assign flushID = PCsel;
    always @ (*) begin
        case (Branch)
        
            3'b000: begin Branchsel = 1'b0; PCsel = 1'b0; end //非跳转指令
            3'b001: begin Branchsel = 1'b0; PCsel = 1'b1; end //jal: 无条件跳转PC目标
            3'b010: begin Branchsel = 1'b1; PCsel = 1'b1; end //jalr: 无条件跳转寄存器目标
            3'b100: begin Branchsel = 1'b0; PCsel = (zero===1'bx)?1'b1:zero; end //beq: 条件分支，等于 修改过
            3'b101: begin Branchsel = 1'b0; PCsel = (zero===1'bx)?1'b1:~zero; end //bne: 条件分支，不等于 修改过
            3'b110: begin Branchsel = 1'b0; PCsel = (result0===1'bx)?1'b1:result0; end //blt, bltu: 条件分支，小于
            3'b111: begin Branchsel = 1'b0; PCsel = (result0===1'bx)?1'b1:(zero | ~result0); end //bge, bgeu: 条件分支，大于等于
            default: begin Branchsel = 1'b0; PCsel = 1'b0; end
            
        endcase
    end
endmodule
