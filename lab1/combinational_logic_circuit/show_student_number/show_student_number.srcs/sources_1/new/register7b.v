`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 11:16:10
// Design Name: 
// Module Name: register7b
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


module register7b(
    output [6:0] q,
    input clk,we,init,
    input [6:0] In,
    input [6:0] Initnum
    );
    reg [6:0] q_r;
    always@(posedge clk)
        begin
            if(we==1) begin
                if(init==1) 
                    q_r<=Initnum;
                else q_r<=In;
            end
        end
    assign q=q_r;
endmodule
