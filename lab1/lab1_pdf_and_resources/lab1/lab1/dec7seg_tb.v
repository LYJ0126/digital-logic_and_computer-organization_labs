`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/09 21:14:59
// Design Name: 
// Module Name: dec7seg_tb
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


module dec7seg_tb(   );
 wire [6:0] O_seg;
 wire [7:0] O_led;
 reg [3:0] I;
 reg [2:0] S;
 integer i;
 dec7seg dec7seg_impl(.O_seg(O_seg),.O_led(O_led),.I(I),.S(S));
 initial begin
   for (i=0;i<=15;i=i+1)
   begin S=i % 8; I=i;#50; end 
   $stop;
 end

endmodule
