`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 22:02:49
// Design Name: 
// Module Name: barrelsft32
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


module barrelsft32(
      output [31:0] dout,
      input [31:0] din,
      input [4:0] shamt,     //“∆∂ØŒª ˝
      input LR,           // LR=1 ±◊Û“∆£¨LR=0 ±”““∆
      input AL            // AL=1 ±À„ ı”““∆£¨AR=0 ±¬ﬂº≠”““∆
	);
//add your code here
    reg [31:0] temp;
    assign dout=temp;
    always @(*) begin
        case ({LR,AL})
                2'b00: begin//¬ﬂº≠”““∆
                        temp = shamt[0]?{1'b0,din[31:1]}:din;
                        temp = shamt[1]?{2'b00,temp[31:2]}:temp;
                        temp = shamt[2]?{4'h0,temp[31:4]}:temp;
                        temp = shamt[3]?{8'h00,temp[31:8]}:temp;
                        temp = shamt[4]?{16'h0000,temp[31:16]}:temp;
                   end
                2'b01: begin//À„ ı”““∆
                        temp = shamt[0]?{din[31],din[31:1]}:din;
                        temp = shamt[1]?{{2{temp[31]}},temp[31:2]}:temp;
                        temp = shamt[2]?{{4{temp[31]}},temp[31:4]}:temp;
                        temp = shamt[3]?{{8{temp[31]}},temp[31:8]}:temp;
                        temp = shamt[4]?{{16{temp[31]}},temp[31:16]}:temp;
                   end
                2'b10,2'b11: begin
                        temp = shamt[0]?{din[30:0],1'b0}:din;
                        temp = shamt[1]?{temp[29:0],2'b00}:temp;
                        temp = shamt[2]?{temp[27:0],4'h0}:temp;
                        temp = shamt[3]?{temp[23:0],8'h00}:temp;
                        temp = shamt[4]?{temp[15:0],16'h0000}:temp;
                    end
        endcase
    end
endmodule
