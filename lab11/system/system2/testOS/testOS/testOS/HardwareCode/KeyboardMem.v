`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2023 02:14:07 PM
// Design Name: 
// Module Name: KeyboardMem
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



module KeyboardMem(
    input  [7:0] datain,
    input wrclk,
    input rdclk,
    input re,
    input we,
    input  read_sig_empty,
    output reg [7:0] dataout
);
    wire full;
    wire empty;
    reg [4:0] head;
    reg [4:0] tail;
    assign full = (tail==((head==0)?31:(head-1)));
    assign empty  = (tail==head);
    reg [7:0] ram[31:0];
    initial
    begin
        head = 0;
        tail = 0;
    end
    always @(posedge   wrclk )
    begin
        if(we && (~full))
        begin
            ram[tail] <= datain ;
            tail <= (tail + 1);
        end
    end
    always @(posedge rdclk )
    begin
        if(re )
            begin
                if(read_sig_empty)
                    dataout <={7'd0,empty };
                else if(~empty)
                begin
                    dataout <= ram[head];
                    head <= (head+1);
                end
            end
        else
            dataout <= 0;
    end
endmodule