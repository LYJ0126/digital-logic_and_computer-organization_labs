`timescale 1ns / 1ps

module divider25MHZ(
    input CLK100MHZ,
    output reg CLK25MHZ,
    output reg CLK1HZ
);
  reg [31:0] counter;
  reg [31:0] cnt;  
  always@(posedge CLK100MHZ)begin
    if(counter == 1)begin
        CLK25MHZ <= ~CLK25MHZ;
        counter <= 0;
    end
    else counter <= counter + 1;
    if(cnt == 50000000 - 1)begin
        CLK1HZ <= ~CLK1HZ;
        cnt <= 0;
    end
    else cnt <= cnt + 1;
  end
endmodule

module xterm(
    input CLK100MHZ,   //系统时钟信号
    input PS2_CLK,    //来自键盘的时钟信号
    input PS2_DATA,  //来自键盘的串行数据位
    input BTNC,      //Reset
    input reset,
    output [6:0]SEG,
    output [7:0]AN,     //显示扫描码和ASCII码
    //output [15:0] LED,   //显示键盘状态
    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B,
    output  VGA_HS,
    output  VGA_VS
);
// Add your code here
wire CLK25MHZ;
wire CLK1HZ;
//clk_wiz_0 myvgaclk(.clk_in1(CLK100MHZ),.reset(rst),.locked(locked),.clk_out1(CLK25MHZ));
divider25MHZ disdsad(.CLK100MHZ(CLK100MHZ),.CLK25MHZ(CLK25MHZ),.CLK1HZ(CLK1HZ));
reg [7:0] screen [29:0][79:0];
reg [7:0] cursor_x;reg [4:0] cursor_y;
reg [4:0]line;
//reg reset;
integer i, m, n;
wire ready;


wire[31:0] keymemout;
wire [31:0] daddr;wire we;wire [31:0] ddatain;
wire kbwe, dwrclk;
assign kbwe = (daddr[31:20] == 12'h003) ? dwe : 0;
KeyboardSim kbsim(.CLK100MHZ(CLK100MHZ),.PS2_CLK(PS2_CLK),.PS2_DATA(PS2_DATA),.BTNC(BTNC)
,.ready(ready)
,.keymemout(keymemout)
,.kbdatain(ddatain)
,.dwrclk(dwrclk)
,.reset(reset)
,.kbaddr(daddr)
,.we(kbwe)
);

wire [11:0] h_addr;
wire [11:0] v_addr;
wire [7:0] asciiin;

assign asciiin = (v_addr/16 == cursor_y && h_addr/8 == cursor_x) ? ((CLK1HZ == 1) ? screen[v_addr/16][h_addr/8] : 0) : screen[v_addr/16][h_addr/8];

wire [3:0] vgar;
wire [3:0] vgag;
wire [3:0] vgab;
assign VGA_R = vgar;
assign VGA_G = vgag;
assign VGA_B = vgab;

VGASim VGASim_vv(.VGA_R(vgar),.VGA_B(vgab),.VGA_G(vgag),.VGA_HS(VGA_HS),.VGA_VS(VGA_VS),.BTNC(BTNC),.CLK25MHZ(CLK25MHZ),
.h_addr(h_addr),.v_addr(v_addr),.asciiin(asciiin));


wire [31:0] PC;
assign PC = mycpu.PC;





    wire [31:0] iaddr,idataout;
wire iclk;
wire [31:0] ddataout;
wire drdclk;
wire [2:0]  dop;
wire [15:0] cpudbgdata;
   reg clk;reg [2:0]couter;
   always @(posedge CLK100MHZ)begin
    if(couter == 3)begin
        couter <= 0;
        clk <= ~clk;
    end
    else begin
        couter <= couter + 1;
        clk <= clk;
    end
   end
   wire [31:0] dataout;
   SingleCycleCPU  mycpu(
.clock(clk), .reset(reset), 
				 .InstrMemaddr(iaddr), .InstrMemdataout(idataout), .InstrMemclk(iclk), 
				 .DataMemaddr(daddr), .DataMemdataout(dataout), .DataMemdatain(ddatain), .DataMemrdclk(drdclk),
				  .DataMemwrclk(dwrclk), .DataMemop(dop), .DataMemwe(dwe),  .dbgdata(cpudbgdata)); 
// instrucation memory
 InstrMem myinstrmem_top(.instr(idataout),.addr(iaddr),.InstrMemEn(1'b1),.clk(iclk)	);
//data memory	
DataMem mydatamem_top(.dataout(ddataout), .clk(dwrclk),  .we(datawe),  .MemOp(dop), .datain(ddatain),.addr(daddr[17:0])); 
   
wire [31:0] vgamemout;
assign datawe = (daddr[31:20] == 12'h001) ? dwe : 1'b0;    
assign vgamemout = screen[lin][col];
assign dataout = (daddr[31:20]==12'h001)? ddataout : ((daddr[31:20] == 12'h003)? keymemout : ((daddr[31:20] == 12'h002) ? vgamemout : 32'b0));

wire [6:0] lin, col;
assign lin = (daddr >> 7) & 7'h7f;
assign col = daddr & 7'h7f;
integer j,k;

always@(negedge dwrclk or posedge reset)begin
if(reset)begin
    for(j = 0; j < 30; j = j + 1)begin
        for(k = 0; k < 80; k = k + 1)begin
            screen[j][k] <= 0;
        end
    end
    cursor_x<=0;
    cursor_y<=0;
end
else if(daddr[31:20] == 12'h002 && dwe == 1'b1)begin
        screen[lin][col] <= ddatain;
        if(ddatain == 32'h5f)begin
            cursor_x <= col;
            cursor_y <= lin;
        end
        else begin
            cursor_x <= cursor_x;
            cursor_y <= cursor_y;
        end
    end

end

 seg7decimal cpuseg(.seg(SEG),.an(AN),.clk(CLK100MHZ),.x(PC));

endmodule

