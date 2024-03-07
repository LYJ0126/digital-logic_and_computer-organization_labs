`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/10 09:38:14
// Design Name: 
// Module Name: KeyboardSim
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


module KeyboardSim(
    input CLK100MHZ,   //系统时钟信号
    input PS2_CLK,    //来自键盘的时钟信号
    input PS2_DATA,  //来自键盘的串行数据位
    input BTNC,      //Reset
    output [6:0]SEG,
    output [7:0]AN,
    output [15:0] LED   //显示
    );
    
// Add your code here

wire ready;
reg CLK50MHZ=0;    
wire [31:0]keycode;

wire rst;
assign rst = BTNC;

always @(posedge(CLK100MHZ))begin
    CLK50MHZ<=~CLK50MHZ;
end

KeyBoardReceiver keyboard_uut(.keycodeout(keycode[31:0]),.ready(ready),.clk(CLK50MHZ),.kb_clk(PS2_CLK),.kb_data(PS2_DATA));

wire [7:0] ascii;
kbcode2ascii kbcode2ascii_inst(.asciicode(ascii), .kbcode(keycode[7:0]));

wire [31:0] seg7_data;
reg [7:0] prev, cur;
reg [7:0] cnt;
reg [7:0] real_ascii;

reg [23:0] prekey;
reg [23:0] curkey;
wire [23:0] nxtkey;
assign nxtkey = {curkey[15:0], keycode[7:0]};

reg CapsLock_state, NumLock_state, LShift_state, RShift_state, LCtrl_state, RCtrl_state, LAlt_state, RAlt_state;
assign LED[15:8] = {CapsLock_state, NumLock_state, LShift_state, RShift_state, LCtrl_state, RCtrl_state, LAlt_state, RAlt_state};
assign LED[7:0] = real_ascii;


assign seg7_data[31:24] = cnt;
assign seg7_data[23:16] = prev;
assign seg7_data[15:8] = cur;
assign seg7_data[7:0] = real_ascii;

initial begin
    cnt <= 0;
    prev <= 0;
    cur <= 0;
    real_ascii <= 0;
    prekey <= 0;
    curkey <= 0;
    CapsLock_state <= 0;
    NumLock_state <= 0;
    LShift_state <= 0;
    RShift_state <= 0;
    LCtrl_state <= 0;
    RCtrl_state <= 0;
    LAlt_state <= 0;
    RAlt_state <= 0;
end

wire iscomp, isbrk;
assign iscomp = keycode[7:0] != 8'he0 && keycode[7:0] != 8'hf0;
assign isbrk = keycode[15:8] == 8'hf0;

always @(posedge ready or posedge rst) begin
    if (rst) begin
        cnt <= 0;
        prev <= 0;
        cur <= 0;
        real_ascii <= 0;
        prekey <= 0;
        curkey <= 0;
        CapsLock_state <= 0; //Questionable
        NumLock_state <= 0; //Questionable
        LShift_state <= 0;
        RShift_state <= 0;
        LCtrl_state <= 0;
        RCtrl_state <= 0;
        LAlt_state <= 0;
        RAlt_state <= 0;
    end
    else begin
        curkey <= nxtkey;
        if (iscomp) begin
        prekey <= nxtkey;
        curkey <= 0;
            if (prekey != nxtkey) begin //Remove same key
                if (isbrk) begin
                    if (keycode[7:0] == 8'h12) LShift_state <= 0;
                    if (keycode[7:0] == 8'h59) RShift_state <= 0;
                    if (keycode[7:0] == 8'h14) begin
                        if (keycode[23:16] != 8'he0) LCtrl_state <= 0;
                        else RCtrl_state <= 0;
                    end
                    if (keycode[7:0] == 8'h11) begin
                        if (keycode[23:16] != 8'he0) LAlt_state <= 0;
                        else RAlt_state <= 0;
                    end
                end
                else begin
                    cnt <= cnt + 1;
                    prev <= cur;
                    cur <= keycode[7:0];
                    real_ascii <= ascii;
                    if (ascii >= 97 && ascii <= 122) begin
                        if ((LShift_state | RShift_state) ^ CapsLock_state)
                            real_ascii <= ascii - 32;
                    end
                    if (keycode[7:0] == 8'h58) CapsLock_state <= ~CapsLock_state;
                    if (keycode[7:0] == 8'h77) NumLock_state <= ~NumLock_state;
                    if (keycode[7:0] == 8'h12) LShift_state <= 1;
                    if (keycode[7:0] == 8'h59) RShift_state <= 1;
                    if (keycode[7:0] == 8'h14) begin
                        if (keycode[15:8] != 8'he0) LCtrl_state <= 1;
                        else RCtrl_state <= 1;
                    end
                    if (keycode[7:0] == 8'h11) begin
                        if (keycode[15:8] != 8'he0) LAlt_state <= 1;
                        else RAlt_state <= 1;
                    end
                end
            end
        end
    end
end

seg7decimal sevenSeg (
.x(seg7_data[31:0]),
.clk(CLK100MHZ),
.seg(SEG[6:0]),
.an(AN[7:0]),
.dp(0)
);
endmodule
