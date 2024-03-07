`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2022 03:46:41 PM
// Design Name: 
// Module Name: branchctr
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


module branchctr(
    input [2:0] Branch,
    input zero,
    input less,

    output reg PCASrc,
    output reg PCBSrc
);
    always @ (*) begin
        case (Branch)
            3'b000: begin PCASrc = 1'b0; PCBSrc = 1'b0; end
            3'b001: begin PCASrc = 1'b1; PCBSrc = 1'b0; end
            3'b010: begin PCASrc = 1'b1; PCBSrc = 1'b1; end
            3'b100: begin PCASrc = zero ? 1'b1 : 1'b0; PCBSrc = 1'b0; end
            3'b101: begin PCASrc = zero ? 1'b0 : 1'b1; PCBSrc = 1'b0; end
            3'b110: begin PCASrc = less ? 1'b1 : 1'b0; PCBSrc = 1'b0; end
            3'b111: begin PCASrc = less ? 1'b0 : 1'b1; PCBSrc = 1'b0; end
        endcase
    end


endmodule
