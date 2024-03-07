`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/13 14:17:15
// Design Name: 
// Module Name: KeyBoardTest
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


module KeyBoardTest(
    output [6:0]SEG,
    output [7:0]AN,
    output DP,
    output ready,
    input CLK100MHZ,
    input PS2_CLK,
    input PS2_DATA
    );
    
reg CLK50MHZ=0;    
wire [31:0]keycode;


always @(posedge(CLK100MHZ))begin
    CLK50MHZ<=~CLK50MHZ;
end

KeyBoardReceiver keyboard_uut(.keycodeout(keycode[31:0]),.ready(ready),.clk(CLK50MHZ),.kb_clk(PS2_CLK),.kb_data(PS2_DATA));

seg7decimal sevenSeg (.x(keycode[31:0]),.clk(CLK100MHZ),.seg(SEG[6:0]),.an(AN[7:0]),.dp(DP) );

endmodule
