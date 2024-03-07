`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/25 23:52:11
// Design Name: 
// Module Name: shrg4u
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


module shrg4u(
    output reg QA, QB, QC, QD,
    input CLK, CLR, S0, S1, RIN, LIN, A, B, C, D
    );
    always @ (posedge CLK)
        if (CLR == 1'b1) {QA,QB,QC,QD} <= 4'b0;
        else case ({S1,S0})
            2'b00: ; // Hold 
            2'b01: {QA,QB,QC,QD} <= {RIN,QA,QB,QC}; // Shift right
            2'b10: {QA,QB,QC,QD} <= {QB,QC,QD,LIN}; // Shift left
            2'b11: {QA,QB,QC,QD} <= {A,B,C,D}; // Load
            default: {QA,QB,QC,QD} <= 4'bx; // should not occur
        endcase
endmodule
