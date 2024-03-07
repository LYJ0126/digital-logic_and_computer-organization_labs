`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/11/2023 10:59:04 PM
// Design Name: 
// Module Name: SimpleOS
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


module SimpleOS(
    input CLK100MHZ,
    input clrn,
    input cpu_reset,
    input vga_reset,
    input ps2_clk,
    input ps2_data,
    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B,
    output VGA_HS,
    output VGA_VS,
    output [7:0] Hex,
    output [7:0] AN
    );
//---------------CLK----------------------
    wire VGA_CLK;
    wire KEYBOARD_CLK;
    wire CPU_CLK;
    wire SEG_CLK;
    //clk_wiz_0 myclk1(.clk_in1(CLK100MHZ),.clk_out1(VGA_CLK));//
    clkgen#(25000000) myclk1(.clkin(CLK100MHZ),.rst(0),.clken(1),.clkout(VGA_CLK ));
    clkgen#(5000000) myclk2(.clkin(CLK100MHZ),.rst(0),.clken(1),.clkout(CPU_CLK ));
    clkgen#(1000) myclk3(.clkin(CLK100MHZ),.rst(0),.clken(1),.clkout(SEG_CLK ));
    clkgen#(10000000) myclk4(.clkin(CLK100MHZ),.rst(0),.clken(1),.clkout(KEYBOARD_CLK ));
    wire [31:0] mscnt;
    Clock myClock(CLK100MHZ ,mscnt );
//--------------CPU------------------------
    
    wire [31:0] imemaddr;
    wire  [31:0] imemdataout;
    wire 	imemclk;
    wire [31:0] addr;
    wire  [31:0] dataout;
    wire [31:0] datain;
    wire 	rdclk;
    wire	wrclk;
    wire [2:0] op;
    wire	we;
    assign dataout = (addr[31:20]  == 12'h001)? dmemdataout:
                    ((addr[31:20] == 12'h003)? {24'd0,keymemout}:
                    ((addr[31:20] == 12'h004)? mscnt:0)
                    );
    rv32is mycpu(CPU_CLK ,cpu_reset,imemaddr ,imemdataout ,imemclk ,addr ,dataout ,datain ,rdclk ,wrclk ,op,we );     
//--------------IMem------------------------------
    InstrMem myinst(.instr(imemdataout),.addr(imemaddr[17:2]),.clk(imemclk));
   // blk_mem_gen_1 myIMem(imemclk ,imemaddr[17:2] ,imemdataout);//0x000//////////////////////////////////////////////////////
//-------------DataMem----------------------------
    
    wire [31:0] datamemaddr;
    assign datamemaddr = addr ;
    wire datamemwe;
    wire [31:0] dmemdataout;
    wire [31:0] dmemdatain;
    assign dmemdatain = datain ;
    assign datamemwe = (addr[31:20] ==12'h001) ? we:0;
    DMem mydatamem(datamemaddr ,dmemdataout ,dmemdatain ,rdclk ,wrclk ,op ,datamemwe );//0x001
    //dmem mydmem(.addr(datamemaddr),.dataout(dmemdataout),.datain(dmemdatain),.rdclk(rdclk),.wrclk(~rdclk),.memop(op),.we(datamemwe));
//-------------Display-------------------------  
    wire [12:0] displaymemwraddr;
    assign displaymemwraddr = addr[12:0] ;
    wire [7:0] start_line;
    wire [12:0] displaymemaddr;
    wire [31:0] displaymemdatain;
    wire displaymemwe;
    assign displaymemdatain  = datain;
    assign displaymemwe  = (addr[31:20] == 12'h002)?we :0;
    wire [7:0] ascii;
    wire [11:0] color;
    Display myDisplay(VGA_CLK,vga_reset,VGA_R ,VGA_G,VGA_B ,VGA_HS ,VGA_VS ,ascii ,color,start_line  ,displaymemaddr);   
    DisplayMem myDisplayMem( {color,ascii},start_line  ,displaymemaddr, displaymemwraddr ,displaymemdatain ,displaymemwe ,wrclk );//0x002
//------------Keyboard-------------------------
    wire keymemewe;
    wire keymemere;
    assign keymemere  = (addr[31:20] == 12'h003)?1:0;
    wire read_sig_empty;
    assign read_sig_empty = (addr[11:0]==12'hfff)?1:0;
    wire [7:0] ascii_key;
    wire [7:0] keymemout;    
    KeyboardMem myKeyBoardMem(ascii_key ,KEYBOARD_CLK    ,rdclk ,keymemere,keymemewe ,read_sig_empty ,keymemout ); 
    Keyboard MYKeyboard(KEYBOARD_CLK  ,clrn,ps2_clk ,ps2_data,keymemewe,ascii_key  );
//----------BCD7SEG-----------
    wire bcd7segwe;
    wire [3:0] bcd7segdatain;
    wire [2:0] bcd7segaddr;
    assign bcd7segwe = (addr[31:20] == 12'h005)?1:0;
    assign bcd7segdatain = datain[3:0];
    assign bcd7segaddr = addr[2:0];
    bcd7seg(datain,bcd7segaddr,wrclk ,SEG_CLK,bcd7segwe ,Hex  ,AN );
endmodule

module InstrMem(
    output reg [31:0] instr, //输出32位指令
    input [15:0] addr,       //32位地址数据，实际有效字长根据指令存储器容量来确定
    input clk               //时钟信号，下降沿有效    
 );
   (* ram_style="distributed" *) reg [31:0] ram[65535:0];//128KB的存储器空间，可存储32k条指令，地址有效长度17位
  initial  begin
  $readmemh("F:/testOS/testOS/SimpleOS/build/target.hex", ram);
  end
    //always @ (*) instr = ram[0];
    always @ (posedge clk) begin
       instr <=ram[addr];
    end
endmodule

/*module dmem(
	input  [31:0] addr,
	output reg [31:0] dataout,
	input  [31:0] datain,
	input  rdclk,
	input  wrclk,
	input [2:0] memop,
	input we);
	
	(* ram_style="block" *) reg [31:0] ram [4095:0];
    initial begin $readmemh("F:/testOS/testOS/SimpleOS/build/target_d.hex", ram);end
    
    reg [31:0] intmp;
    reg [31:0] outtmp;
    
    always @ (posedge rdclk) begin
        outtmp <= ram[addr[13:2]];
    end
    always @(posedge wrclk) begin
        if(we) ram[addr[13:2]] <= intmp;
    end
    wire [4:0] r_start;
    assign r_start = addr[1: 0] << 3;
    always @(*) begin
        if(~we) begin
            case(memop)
                3'b000: begin dataout = {{24{outtmp[r_start+7]}}, outtmp[r_start+:8]} ; end
                3'b001: begin dataout = {{16{outtmp[r_start+15]}}, outtmp[r_start+:16]} ; end
                3'b010: begin dataout = outtmp; end
                3'b100: begin dataout = {24'h000000, outtmp[r_start+:8]}; end
                3'b101: begin dataout = {16'h0000, outtmp[r_start+:16]}; end
                default: dataout = outtmp;
            endcase
        end
        else begin
            case (memop)
                3'b000: begin intmp = outtmp; intmp[r_start+:8] = datain[7:0]; end
                3'b001: begin intmp = outtmp; intmp[r_start+:16] = datain[15:0] ; end
                3'b010: begin intmp = datain; end
                default: intmp = datain;
            endcase
        end
    end
endmodule*/