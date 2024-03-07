`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/02 00:43:37
// Design Name: 
// Module Name: mul_32p_tb
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


module mul_32k_tb(    );
  parameter N = 32;               // 定义位宽
  parameter SEED = 1;              // 定义不同的随机序列
  reg [N-1:0] X, Y;
  wire [2*N-1:0] P;

  mul_32k UUT ( .X(X), .Y(Y), .P(P) ); // Instantiate the UUT
  integer i,errors;
  reg [2*N-1:0] temp_P;
  /*initial begin
    errors=0;
    X=32'h00888888;
    Y=32'h99999999;
    temp_P=X*Y;
    if(P!=temp_P) begin
        errors=errors+1;
    end
    #100;
    X=32'h00000007;
    Y=32'h0000000f;
    temp_P=X*Y;
    if(P!=temp_P) begin
        errors=errors+1;
    end
    #100;
    X=32'hffffffff;
    Y=32'hfffffff8;
    temp_P=X*Y;
    if(P!=temp_P) begin
        errors=errors+1;
    end
  end*/
  task checkP;
    begin
      temp_P = X*Y;
      if (P !== temp_P) begin
        errors=errors+1;
        $display($time," Error: X=%d, Y=%d, expected %d (%16H), got %d (%16H)",
                 X, Y, temp_P, temp_P, P, P); $stop(1); end
    end
  endtask
  initial begin : TB   // Start testing at time 0
    errors=0;
    X=$random(SEED);
    for ( i=0; i<=10000; i=i+1 ) begin
      X=$random;   Y=$random;
     #10;           // wait 10 ns, then check result
        checkP;
      end
    $display($time, " Test ended. Errors:%d",errors); $stop(1);          // end test
  end

endmodule
