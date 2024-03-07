`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/27 23:09:20
// Design Name: 
// Module Name: regfile32
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


module regfile32(
   output  [31:0] busa,
   output  [31:0] busb,
   input [31:0] busw,
   input [4:0] ra,
   input [4:0] rb,
   input [4:0] rw,
   input clk, we
    );
    reg [31:0] regfiles [31:0];

initial begin
    regfiles[0] = 0;
end

always @(posedge clk) begin
    if (we && (rw > 0)) begin
        regfiles[rw] <= busw;
    end
end

assign busa = regfiles[ra];
assign busb = regfiles[rb];
endmodule
