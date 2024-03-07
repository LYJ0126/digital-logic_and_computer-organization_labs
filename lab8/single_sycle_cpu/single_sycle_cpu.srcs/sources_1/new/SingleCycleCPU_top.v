`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/28 00:32:24
// Design Name: 
// Module Name: SingleCycleCPU_top
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


module SingleCycleCPU_top(
output [6:0] segs,           //七段数码管字形输出
output [7:0] AN,            //七段数码管显示32位运算结果 
input CLK100MHZ,
input BTNC,
input [11:0] nin
    );
    clk_wiz clk_wiz_inst(
    .clk_out1(clk),     // output clk_out1
    .reset(1'b0), // input reset
    .locked(1'b0),       // output locked
    .clk_in1(CLK100MHZ));      // input clk_in1


// signals
wire [31:0] iaddr;
wire [31:0] idataout;
wire iclk;
wire [31:0] daddr,ddataout,ddatain;
wire drdclk, dwrclk, dwe;
wire [2:0]  dop;
wire [15:0] cpudbgdata;

wire [31:0] dddataout;

//main CPU
SingleCycleCPU  mycpu(.clock(clk), 
                 .reset(BTNC), 
				 .InstrMemaddr(iaddr), .InstrMemdataout(idataout), .InstrMemclk(iclk), 
				 .DataMemaddr(daddr), .DataMemdataout(dddataout), .DataMemdatain(ddatain), .DataMemrdclk(drdclk),
				  .DataMemwrclk(dwrclk), .DataMemop(dop), .DataMemwe(dwe),  .dbgdata(cpudbgdata));

reg [31:0] value;

always @(negedge clk) begin
    if (BTNC) begin 
        value <= 0; 
    end
    else begin
        value <= mycpu.myregfile.regfiles[10];
    end
end

Segdisplay mySegdisplay(.clk(clk), .value(value), .segs(segs), .AN(AN));
endmodule
