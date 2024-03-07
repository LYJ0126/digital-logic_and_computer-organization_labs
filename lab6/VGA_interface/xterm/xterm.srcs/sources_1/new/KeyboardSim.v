`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/30 20:54:17
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
    output [15:0] LED,   //显示
    output [7:0] ascii_out,
    output [7:0] cnt_out
    );
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
assign ascii_out = real_ascii;
assign cnt_out = cnt;

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

reg [7:0] pre_cnt;

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
    pre_cnt <= 0;
end

wire iscomp, isbrk;
assign iscomp = keycode[7:0] != 8'he0 && keycode[7:0] != 8'hf0;
assign isbrk = keycode[15:8] == 8'hf0;

parameter [7:0] CapsLock_kc = 8'h58;
parameter [7:0] NumLock_kc = 8'h77;
parameter [7:0] LShift_kc = 8'h12;
parameter [7:0] RShift_kc = 8'h59;
parameter [7:0] Ctrl_kc = 8'h14;
parameter [7:0] Alt_kc = 8'h11;

parameter [7:0] Leftarrow_kc = 8'h6b;
parameter [7:0] Rightarrow_kc = 8'h74;
parameter [7:0] Uparrow_kc = 8'h75;
parameter [7:0] Downarrow_kc = 8'h72;

always @(posedge ready or posedge rst) begin
    if (rst) begin
        cnt <= 0;
        prev <= 0;
        cur <= 0;
        real_ascii <= 0;
        prekey <= 0;
        curkey <= 0;
        CapsLock_state <= 0; //Questionable
        NumLock_state <= 1; //Questionable
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
                    if (keycode[7:0] == LShift_kc) LShift_state <= 0;
                    if (keycode[7:0] == RShift_kc) RShift_state <= 0;
                    if (keycode[7:0] == Ctrl_kc) begin
                        if (keycode[23:16] != 8'he0) LCtrl_state <= 0;
                        else RCtrl_state <= 0;
                    end
                    if (keycode[7:0] == Alt_kc) begin
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
                        if ((LShift_state | RShift_state) ^ CapsLock_state) begin
                            real_ascii <= ascii - 32;
                        end
                    end
                    else if (LShift_state | RShift_state) begin
                        case (ascii)
                            49: real_ascii <= 33;
                            50: real_ascii <= 64;
                            51: real_ascii <= 35;
                            52: real_ascii <= 36;
                            53: real_ascii <= 37;
                            54: real_ascii <= 94;
                            55: real_ascii <= 38;
                            56: real_ascii <= 42;
                            57: real_ascii <= 40;
                            48: real_ascii <= 41;
                            45: real_ascii <= 95;
                            61: real_ascii <= 43;
                            91: real_ascii <= 123;
                            93: real_ascii <= 125;
                            92: real_ascii <= 124;
                            59: real_ascii <= 58;
                            39: real_ascii <= 34;
                            44: real_ascii <= 60;
                            46: real_ascii <= 62;
                            47: real_ascii <= 63;
                            default: real_ascii <= ascii;
                        endcase
                    end
                    else if (NumLock_state) begin
                        case (keycode[7:0])
                            8'h71: real_ascii <= 0;
                            8'h70: real_ascii <= 0;
                            8'h69: real_ascii <= 0;
                            8'h72: real_ascii <= 0;
                            8'h7a: real_ascii <= 0;
                            8'h6b: real_ascii <= 0;
                            8'h73: real_ascii <= 0;
                            8'h74: real_ascii <= 0;
                            8'h6c: real_ascii <= 0;
                            8'h75: real_ascii <= 0;
                            8'h7d: real_ascii <= 0;
                        endcase
                    end
                    if (keycode[7:0] == CapsLock_kc) CapsLock_state <= ~CapsLock_state;
                    if (keycode[7:0] == NumLock_kc) NumLock_state <= ~NumLock_state;
                    if (keycode[7:0] == LShift_kc) LShift_state <= 1;
                    if (keycode[7:0] == RShift_kc) RShift_state <= 1;
                    if (keycode[7:0] == Ctrl_kc) begin
                        if (keycode[15:8] != 8'he0) LCtrl_state <= 1;
                        else RCtrl_state <= 1;
                    end
                    if (keycode[7:0] == Alt_kc) begin
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
.an(AN[7:0])
);

endmodule
