`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/16 19:35:09
// Design Name: 
// Module Name: compare32b_tb
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


module compare32b_tb();
    reg [31:0] P, Q;
    wire PGTQ, PEQQ, PLTQ;
    integer ii, errors;
    compare32b UUT ( .P(P), .Q(Q), .PGTQ(PGTQ), .PEQQ(PEQQ), .PLTQ(PLTQ) );
    initial begin
        errors = 0;
        P = $random(1); // 设置随机数模式
        for (ii=0; ii<10000; ii=ii+1) begin
            P = $random; Q = $random;
            #10 ;
            if ( (PGTQ) !== (P>Q) || (PLTQ) !== (P<Q) || (PEQQ) !== (P==Q) ) 
            begin
                errors = errors + 1;
                $display("P=%b(%0d), Q=%b(%0d), PGTQ=%b, PEQQ=%b, PLTQ=%b",P, P, Q, Q, PGTQ, PEQQ, PLTQ);
            end
        end
        $display("Test done, %0d errors", errors);
    end
endmodule
