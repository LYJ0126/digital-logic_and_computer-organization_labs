`timescale 1ns / 1ps

module ASCII(
input clk,
input [7:0] addr,
output [127:0] outdata
    );

reg [127:0] ascii_mem[255:0];

initial
begin
    $readmemh("C:/Vivadolabs/lab6/lab6_pdf_and_resources/lab6/ASC16.txt", ascii_mem, 0, 255);
end
assign outdata = ascii_mem[addr];

endmodule
