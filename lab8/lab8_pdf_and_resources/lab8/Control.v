`timescale 1ns / 1ps

module Control(
    output [2:0] ExtOp,
    output RegWr,
    output ALUASrc,
    output [1:0] ALUBSrc,
    output [3:0] ALUctr,
    output [2:0] Branch,
    output MemtoReg,
    output MemWr,
    output [2:0] MemOp,
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7
   );

    wire U_lui   = opcode == 7'h37;
    wire U_auipc = opcode == 7'h17;
    wire I_Arith = opcode == 7'h13;
    wire R_Arith = opcode == 7'h33;
    wire J_jal   = opcode == 7'h6f;
    wire J_jalr  = opcode == 7'h67;
    wire B_Instr = opcode == 7'h63;
    wire I_load  = opcode == 7'h03;
    wire S_Instr = opcode == 7'h23;
    wire halt    = opcode == 7'h00;

    assign ExtOp = U_lui | U_auipc ? 3'b001
                 : S_Instr         ? 3'b010
                 : B_Instr         ? 3'b011
                 : J_jal           ? 3'b100
                 : 3'b000;
    assign RegWr = U_lui | U_auipc | J_jal | J_jalr | I_Arith | I_load | R_Arith;
    assign ALUASrc = U_auipc | J_jal | J_jalr;
    assign ALUBSrc = J_jal | J_jalr ? 2'b01
                   : U_lui | U_auipc | I_Arith | I_load | S_Instr ? 2'b10
                   : 2'b00;
    assign ALUctr[3] = U_lui | (R_Arith && funct3 == 3'b000 && funct7[5] == 1'b1) | ((I_Arith || R_Arith) && funct3 == 3'b101 && funct7[5] == 1'b1);
    assign ALUctr[2] = U_lui | ((I_Arith || R_Arith) && funct3[2]);
    assign ALUctr[1] = U_lui | ((I_Arith || R_Arith) && funct3[1]) | B_Instr;
    assign ALUctr[0] = U_lui | ((I_Arith || R_Arith) && funct3[0]) | (B_Instr && funct3[2] && funct3[1]);
    assign Branch = J_jal                      ? 3'b001
                  : J_jalr                     ? 3'b010
                  : B_Instr & funct3 == 3'b000 ? 3'b100
                  : B_Instr & funct3 == 3'b001 ? 3'b101
                  : B_Instr & (funct3 == 3'b110 | funct3 == 3'b100) ? 3'b110
                  : B_Instr & (funct3 == 3'b101 | funct3 == 3'b111) ? 3'b111
                  : 3'b000;
    assign MemtoReg = I_load;
    assign MemWr = S_Instr;
    /*
    assign MemOp = funct3 == 3'b010 ? 3'b000
                 : funct3 == 3'b100 ? 3'b001
                 : funct3 == 3'b101 ? 3'b010
                 : funct3 == 3'b000 ? 3'b101
                 : funct3 == 3'b001 ? 3'b110
                 : 3'b000;
    */
    assign MemOp = funct3;
endmodule
