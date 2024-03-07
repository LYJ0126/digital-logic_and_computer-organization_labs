`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 22:03:05
// Design Name: 
// Module Name: barrelsft32_tb
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


module barrelsft32_tb( );
 parameter N = 32;      // Operand widths
 parameter SEED = 1;    // Change for a different random sequence
 wire [N-1:0] DOUT;
 reg signed [N-1:0] DIN;  //必须设置成带符号数，否则算术右移出错
 reg [4:0] SHAMT;      //移动位数
 reg LR;               // LR=1 时左移,LR=0 时右移
 reg AL;              // AL=1 时算术右移,AR=0 时逻辑右移
  integer i, sh, errors;
  reg [N-1:0] xpectS; 
 
  barrelsft32 barrelsft32_inst(.dout(DOUT),.din(DIN),.shamt(SHAMT),.LR(LR),.AL(AL));

  task checksh;   // Task to compare barrelsft32_inst output (DOUT) with expected (xpectS)
   input LR,AL;
   begin
      xpectS=((LR==1) ? ((DIN << SHAMT) ):((AL==1) ?(DIN >>> SHAMT ):(DIN >> SHAMT)));
        if (xpectS!==DOUT) begin
        errors = errors + 1;
        $display("Error: LR=%1B,AL=%1B,SHAMT=%5b, DIN=%32b, want= %32b, got= %32b", LR, AL, SHAMT,DIN, xpectS, DOUT);
      end
    end
  endtask
  
  initial begin
    errors = 0; DIN = $random(SEED);
    for (i=0; i<2500; i=i+1) begin      // Test 2500 random input data vectors
      DIN = $random;                    // Apply random data input
      for (sh=1; sh<=N-1; sh=sh+1) begin // Test all possible shift amounts
        SHAMT = sh;                         // Apply shift amount
                                       
        LR=1'b0;AL=1'b0; #10  ; checksh(LR,AL);
        LR=1'b0;AL=1'b1; #10  ; checksh(LR,AL);
        LR=1'b1;AL=1'b0; #10  ; checksh(LR,AL);
        LR=1'b1;AL=1'b1; #10  ; checksh(LR,AL);
      end
    end
    $display("BarrelShifter32 test done, %0d errors.", errors); $fflush; 
    $stop(1);
  end
endmodule
