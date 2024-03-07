`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/16 20:21:40
// Design Name: 
// Module Name: decode5to32_tb
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


module decode5to32_tb();
    reg [4:0] In;
    reg En;
    wire [31:0] Out;
    integer i,errors;
    reg [31:0] expectY;
    decode5to32 dec(.Out(Out),.In(In),.En(En));
     initial
        begin
            errors=0;
            In=$random(1);
            En=$random(2);
            for(i=0;i<200;i=i+1)
             begin
                En={$random}%2;
                In={$random}%32;
                #20;
                expectY=32'b00000000000000000000000000000000;
                if(En==1) expectY[In]=1'b1;
                if(Out!=expectY) begin
                    $display("Error: En=%b, In = %3b, out = %8b", En, In, Out);
                    errors = errors + 1;
                end
             end
             $display("Test complete, %d errors",errors);
        end
endmodule
