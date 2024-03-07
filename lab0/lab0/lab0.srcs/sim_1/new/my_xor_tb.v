`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/06 16:33:41
// Design Name: 
// Module Name: my_xor_tb
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


module my_xor_tb();
    wire f;
    reg a,b;
    my_xor s0(.A(a),.B(b),.F(f));
    initial begin
     begin a= 1'b0; b=1'b0; end
     #200 begin a = 1'b0; b = 1'b1; end
     #200 begin a = 1'b1; b = 1'b0; end 
     #200 begin a = 1'b1; b = 1'b1; end
     #200 begin a = 1'b0; b = 1'b0; end
    end
endmodule
