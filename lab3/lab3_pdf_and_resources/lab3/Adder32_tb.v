`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 22:02:27
// Design Name: 
// Module Name: Adder32_tb
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


module Adder32_tb(    );
  parameter N = 32;      // Operand widths
  parameter SEED = 1;    // Change for a different random sequence
  reg [N-1:0] A, B;
  reg CIN;
  wire [N-1:0] S;
  wire COUT;
  wire OF,SF,ZF,CF;
  integer i, errors;
  reg xpectCF;
  reg [N-1:0] xpectS;

   Adder32 adder_inst(.f(S),.OF(OF),.SF(SF),.ZF(ZF),.CF(CF),.cout(COUT),.x(A),.y(B),.sub(CIN));
  task checkadd;
    begin
       {xpectCF,xpectS} = (CIN ? (A-B):(A+B));          //Verilog 加减运算结果比操作数增加1位，表示进位和借位。CIN=1表示减法运算
      if ( (xpectCF!==CF) || (xpectS!==S) ) begin
        errors = errors + 1;
        $display("ERROR: CIN,A,B = %1b,%8h,%8h, CF,S = %1b,%8h, should be %1b,%8h, OF,SF,ZF,COUT=%1b, %1b, %1b, %1b." ,
                 CIN, A, B, CF, S, xpectCF, xpectS ,OF,SF,ZF,COUT);
      end
      if ((B==A) && (CIN==1)&&(ZF==0 )) begin
        errors = errors + 1;
        $display("ERROR: CIN,A,B = %1b,%8h,%8h, CF,S = %1b,%8h, should be %1b,%8h, OF,SF,ZF,COUT=%1b, %1b, %1b, %1b." ,
                 CIN, A, B, CF, S, xpectCF, xpectS ,OF,SF,ZF,COUT);
      end
      if (((B[N-1]&A[N-1]&~S[N-1]) |(~A[N-1]&~B[N-1]&S[N-1]))  & (OF==0 )) begin
        errors = errors + 1;
        $display("ERROR: CIN,A,B = %1b,%8h,%8h, CF,S = %1b,%8h, should be %1b,%8h, OF,SF,ZF,COUT=%1b, %1b, %1b, %1b." ,
                 CIN, A, B, CF, S, xpectCF, xpectS ,OF,SF,ZF,COUT);
      end
    end
  endtask
  
  initial begin
    errors = 0;
           A = $random(SEED);                           // Set pattern based on seed parameter
   for (i=0; i<10000; i=i+1) begin             //计算10000次
          B = ~A; CIN = 0;  #10 ; checkadd;     // B是A的反码，相加
          B = ~A; CIN = 1;  #10 ; checkadd;     // B是A的反码，相减
          B = A;  CIN = 1;  #10 ; checkadd;    // 相等做减法，判断ZF
          A = $random; B= $random;                          
          CIN = 0; #10 ; checkadd;          // Check again
          CIN = 1; #10 ; checkadd;          // Try both values of CIN
    end
    $display("Adder32 test done. Errors: %0d .", errors);
    $stop(1);
  end

endmodule
