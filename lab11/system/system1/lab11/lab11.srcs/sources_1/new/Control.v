`timescale 1ns / 1ps

module Control(
input ban,
    output reg [2:0] ExtOp,
    output reg RegWr,
    output reg ALUASrc,
    output reg [1:0] ALUBSrc,
    output reg [3:0] ALUctr,
    output reg [2:0] Branch,
    output reg MemtoReg,
    output reg MemWr,
    output reg [2:0] MemOp,
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7    
   );
// Add your code here   
always@(*)begin
if (ban) begin
            ExtOp = 3'b000;
            Branch = 3'b000;
            ALUBSrc = 2'b00;
            ALUctr = 4'b0000;
            MemOp = 3'b000;
            RegWr = 0;
            MemtoReg = 0;
            ALUASrc = 0;
            MemWr = 0;
        end
else begin
    if(opcode == 7'b0110111)
        begin
         ExtOp = 3'b001; RegWr = 1'b1; ALUBSrc = 2'b10; ALUctr = 4'b1111; Branch = 3'b000;MemtoReg = 1'b0;MemWr=1'b0; 
        MemOp = 3'b000; ALUASrc = 1'b0; 
        end
    else if(opcode == 7'b0010111) 
        begin 
        ExtOp = 3'b001; RegWr = 1'b1; ALUASrc = 1'b1; ALUBSrc = 2'b10; ALUctr = 4'b0000; Branch = 3'b000;MemtoReg = 1'b0;MemWr=1'b0;
        MemOp = 3'b000;
        end
    else if(opcode == 7'b0010011)begin
    Branch = 3'b000;MemtoReg = 1'b0;MemWr=1'b0; MemOp = 3'b000;
        ExtOp = 3'b000;
        RegWr = 1'b1;
        ALUASrc = 1'b0; ALUBSrc = 2'b10;
        if(funct3 == 3'b101 && funct7[5] == 1'b1)begin 
            ALUctr = {1'b1, funct3};
        end
        else begin ALUctr = {1'b0, funct3}; end
    end
    else if(opcode == 7'b0110011)begin
    Branch = 3'b000;MemtoReg = 1'b0;MemWr=1'b0;
        RegWr = 1'b1; ALUctr = {funct7[5], funct3};
        ALUASrc = 1'b0; ALUBSrc = 2'b00;MemOp = 3'b000; ExtOp = 3'b000;
    end
    else if(opcode == 7'b1101111)begin
    Branch = 3'b001;MemtoReg = 1'b0;MemWr=1'b0;MemOp = 3'b000;
        ExtOp = 3'b100;RegWr = 1'b1;ALUASrc = 1'b1; ALUBSrc = 2'b01; ALUctr = 4'b0000;
    end
    else if(opcode == 7'b1100111)begin
        if(funct3 == 3'b000)
            begin ExtOp = 3'b000; RegWr = 1'b1; ALUASrc = 1'b1; ALUBSrc = 2'b01; ALUctr = 4'b0000; Branch = 3'b010;MemtoReg = 1'b0;MemWr=1'b0; MemOp = 3'b000;end
        else begin ExtOp = 3'b000; RegWr = 1'b0; ALUASrc = 1'b0; ALUBSrc = 2'b00; ALUctr = 4'b0000;Branch = 3'b000;MemtoReg = 1'b0;MemWr=1'b0; MemOp = 3'b000;end
    end
    else if(opcode == 7'b1100011)begin
        ExtOp = 3'b011; RegWr = 1'b0; ALUASrc = 1'b0; ALUBSrc = 2'b00;  MemOp = 3'b000;
        if(funct3 == 3'b000)begin ALUctr = 4'b0010; Branch = 3'b100;MemtoReg = 1'b0;MemWr=1'b0; end
        else if(funct3 == 3'b001)begin ALUctr = 4'b0010; Branch = 3'b101;MemtoReg = 1'b0;MemWr=1'b0;end
        else if(funct3 == 3'b100)begin ALUctr = 4'b0010;Branch = 3'b110;MemtoReg = 1'b0;MemWr=1'b0;end
        else if(funct3 == 3'b101)begin ALUctr = 4'b0010;Branch = 3'b111;MemtoReg = 1'b0;MemWr=1'b0;end
        else if(funct3 == 3'b110)begin ALUctr = 4'b0011;Branch = 3'b110;MemtoReg = 1'b0;MemWr=1'b0;end
        else if(funct3 == 3'b111)begin ALUctr = 4'b0011;Branch = 3'b111;MemtoReg = 1'b0;MemWr=1'b0;end
    end
    else if(opcode == 7'b0000011)begin
    Branch = 3'b000;MemtoReg = 1'b1;MemWr=1'b0;
    MemOp = funct3;
        ExtOp = 3'b000; RegWr = 1'b1; ALUASrc = 1'b0; ALUBSrc = 2'b10;ALUctr = 4'b0000;
    end
    else if(opcode == 7'b0100011)begin
    Branch = 3'b000;MemtoReg = 1'b0;MemWr=1'b1;MemOp = funct3;
        ExtOp = 3'b010; RegWr = 1'b0; ALUASrc = 1'b0; ALUBSrc = 2'b10;ALUctr = 4'b0000;
    end
end
end
endmodule
