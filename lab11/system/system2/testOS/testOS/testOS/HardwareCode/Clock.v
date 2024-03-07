`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2023 09:47:37 PM
// Design Name: 
// Module Name: Clock
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
module Clock(
    input CLK100MHZ,
    output integer mscnt
);
    integer clkcount = 0;
    integer countlimit = 49999;
    always @(posedge CLK100MHZ )
    begin
       if(clkcount>=countlimit)
                            begin
                                clkcount<=32'd0;
                                mscnt<=mscnt+1;
                            end
                        else
                            begin
                                clkcount<=clkcount+1;
                            end
    end
endmodule

module clkgen(
    input clkin,
    input rst,
    input clken,
    output reg clkout
    );
    parameter clk_freq=1;
    parameter countlimit = 100000000/2/clk_freq-1;
    reg[31:0] clkcount;
    always@(posedge clkin)
        if(rst)
            begin
                clkcount<=0;
                clkout<=1'b0;
            end
        else
            begin
                if(clken)
                    begin
                        if(clkcount>=countlimit)
                            begin
                                clkcount<=32'd0;
                                clkout<=~clkout;
                            end
                        else
                            begin
                                clkcount<=clkcount+1;
                            end
                    end
            end
    
    
endmodule