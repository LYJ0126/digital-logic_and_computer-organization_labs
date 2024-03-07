`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/16 21:14:24
// Design Name: 
// Module Name: show_student_number_tb
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


module show_student_number_tb();
    wire [7:0] O_led;
    wire [6:0] O_seg;
    wire cou,chan,tim;
    reg clk;
    integer i;
    show_student_number ssn(.O_led(O_led),.O_seg(O_seg),.clk(clk),.cou(cou),.chan(chan),.tim(tim));
    initial begin
        clk=1'b0;
        #2 clk=1'b1;
        #2 clk=1'b0;
        for(i=0;i<50;i=i+1)
            begin
                #2 clk=1'b1;
                #2 clk=1'b0;
            end
    end
endmodule
