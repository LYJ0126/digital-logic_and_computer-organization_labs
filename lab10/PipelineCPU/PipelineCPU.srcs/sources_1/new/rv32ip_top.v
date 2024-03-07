`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/08 16:27:27
// Design Name: 
// Module Name: rv32ip_top
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


module rv32ip_top(
input CLK100MHZ,
input [11:0] n,//入参
input reset,
output [15:0] sum,//累加和
output [6:0] segs,
output [7:0] AN
    );
wire [31:0] iaddr,idataout;
wire iclk;
wire [31:0] daddr,ddataout,ddatain;
wire drdclk, dwrclk, dwe;
wire [2:0]  dop;
wire [31:0] cpudbgdata;
wire clk;

clkgen myclkgen(.clkin(CLK100MHZ),.rst(1'b0),.clken(1'b1),.clkout(clk));
rv32ip  mycpu(.a0({20'h00000, n}),.clock(clk), .reset(reset), 
				 .imemaddr(iaddr), .imemdataout(idataout), .imemclk(iclk), 
				 .dmemaddr(daddr), .dmemdataout(ddataout), .dmemdatain(ddatain), .dmemrdclk(drdclk),
				  .dmemwrclk(dwrclk), .dmemop(dop), .dmemwe(dwe),  .dbgdata(cpudbgdata)); 
// instrucation memory
 InstrMem myinstrmem(.instr(idataout),.addr(iaddr),.InstrMemEn(1'b1),.clk(iclk)	);
//data memory	
DataMem mydatamem(.dataout(ddataout), .clk(dwrclk),  .we(dwe),  .MemOp(dop), .datain(ddatain),.addr(daddr[15:0])); 
    
    assign sum = mycpu.myregfile.regfiles[10][15:0];
    wire [31:0]res;
    assign res = mycpu.myregfile.regfiles[10];//a0寄存器为10号寄存器,是入参寄存器，也是结果寄存器

reg [15:0] counter;//数码管刷新计数器
reg [7:0] anout;
reg [6:0] segsout;
wire [6:0] connection [7:0];
assign segs=segsout;
assign AN=anout;
seg_decode seg_7(.in(res[31:28]),.out(connection[7]));
seg_decode seg_6(.in(res[27:24]),.out(connection[6]));
seg_decode seg_5(.in(res[23:20]),.out(connection[5]));
seg_decode seg_4(.in(res[19:16]),.out(connection[4]));
seg_decode seg_3(.in(res[15:12]),.out(connection[3]));
seg_decode seg_2(.in(res[11:8]),.out(connection[2]));
seg_decode seg_1(.in(res[7:4]),.out(connection[1]));
seg_decode seg_0(.in(res[3:0]),.out(connection[0]));
//数码管显示
always @(posedge CLK100MHZ) begin
    counter<=counter+1;
        case (counter)
            6000: begin
                anout<=8'b01111111;
                segsout<=connection[7];
            end
            12000: begin
                anout<=8'b10111111;
                segsout<=connection[6];
            end
            18000: begin
                anout<=8'b11011111;
                segsout<=connection[5];
            end
            24000: begin
                anout<=8'b11101111;
                segsout<=connection[4];
            end
            30000: begin
                anout<=8'b11110111;
                segsout<=connection[3];
            end
            36000: begin
                anout<=8'b11111011;
                segsout<=connection[2];
            end
            42000: begin
                anout<=8'b11111101;
                segsout<=connection[1];
            end
            48000: begin
                anout<=8'b11111110;
                segsout<=connection[0];
                counter<=0;
            end
        endcase
end
endmodule
