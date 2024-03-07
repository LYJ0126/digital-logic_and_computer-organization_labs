`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/13 23:05:31
// Design Name: 
// Module Name: MouseReceiver
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


module MouseReceiver(
    output [6:0]SEG,
    output [7:0]AN,
    output DP,
    output LeftButton,   //左键按下
    output RightButton,  //左键按下
    output ready,
    input CLK100MHZ,
    input PS2_CLK,
    input PS2_DATA
    );
 // add your code here
    reg inerror;
    reg withroll;
    reg [7:0] testinfo;
    reg [7:0] mouseinfo;
    reg [7:0] initcnt;
    reg [7:0] cnt;
    reg [63:0] mousecode;
    reg [31:0] codecur;
    reg [31:0] codeprev;
    reg readyflag [3:0];
    reg flag;//接受1帧数据
    reg [15:0] counter;//数码管刷新计数器
    wire [6:0] connection [4:0];
    reg [7:0] anout;
    reg [6:0] segsout;
    assign SEG=segsout;
    assign AN=anout;
    assign LeftButton=mousecode[0];
    assign RightButton=mousecode[1];
    assign DP=1'b1;
    assign ready=readyflag[0];
    initial begin
        mousecode<=8'h00000000;
        cnt<=0;
        initcnt<=0;
    end
    /*always @(negedge PS2_CLK) begin
        if(initcnt<=15)begin
            initcnt<=initcnt+1;
            case(initcnt)
                0:testinfo[0]<=PS2_DATA;
                1:testinfo[1]<=PS2_DATA;
                2:testinfo[2]<=PS2_DATA;
                3:testinfo[3]<=PS2_DATA;
                4:testinfo[4]<=PS2_DATA;
                5:testinfo[5]<=PS2_DATA;
                6:testinfo[6]<=PS2_DATA;
                7:testinfo[7]<=PS2_DATA;
                8: begin
                    if(testinfo==8'haa) begin
                        inerror=1'b0;
                    end
                    else if(testinfo==8'hfc) begin
                        inerror=1'b1;
                    end
                        mouseinfo[0]<=PS2_DATA;
                end
                9:mouseinfo[1]<=PS2_DATA;
                10:mouseinfo[2]<=PS2_DATA;
                11:mouseinfo[3]<=PS2_DATA;
                12:mouseinfo[4]<=PS2_DATA;
                13:mouseinfo[5]<=PS2_DATA;
                14:mouseinfo[6]<=PS2_DATA;
                15:begin 
                      mouseinfo[7]<=PS2_DATA;
                      initcnt<=16;
                      if(mouseinfo==8'h03) begin withroll=1'b1; end
                      else if(mouseinfo==8'h00) begin withroll=1'b0; end
                   end
            endcase
        end
        else begin
            initcnt<=16;
        end
    end*/
    always @(negedge PS2_CLK) begin
        /*if(initcnt>15) begin
            if(inerror==1'b0)begin
                if(withroll==1'b1)begin//有滚轮*/
                    case(cnt)
                        0:readyflag[0]<=1'b0;
                        1:codecur[0]<=PS2_DATA;
                        2:codecur[1]<=PS2_DATA;
                        3:codecur[2]<=PS2_DATA;
                        4:codecur[3]<=PS2_DATA;
                        5:codecur[4]<=PS2_DATA;
                        6:codecur[5]<=PS2_DATA;
                        7:codecur[6]<=PS2_DATA;
                        8:codecur[7]<=PS2_DATA;
                        9:flag<=1'b1;
                        10:flag<=1'b0;//第一帧结束
                        11:readyflag[1]<=1'b0;
                        12:codecur[8]<=PS2_DATA;
                        13:codecur[9]<=PS2_DATA;
                        14:codecur[10]<=PS2_DATA;
                        15:codecur[11]<=PS2_DATA;
                        16:codecur[12]<=PS2_DATA;
                        17:codecur[13]<=PS2_DATA;
                        18:codecur[14]<=PS2_DATA;
                        19:codecur[15]<=PS2_DATA;
                        20:flag<=1'b1;
                        21:flag<=1'b0;//第二帧结束
                        22:readyflag[2]<=1'b0;
                        23:codecur[16]<=PS2_DATA;
                        24:codecur[17]<=PS2_DATA;
                        25:codecur[18]<=PS2_DATA;
                        26:codecur[19]<=PS2_DATA;
                        27:codecur[20]<=PS2_DATA;
                        28:codecur[21]<=PS2_DATA;
                        29:codecur[22]<=PS2_DATA;
                        30:codecur[23]<=PS2_DATA;
                        31:flag<=1'b1;
                        32:flag<=1'b0;
                        33:readyflag[3]<=1'b0;
                        34:codecur[24]<=PS2_DATA;
                        35:codecur[25]<=PS2_DATA;
                        36:codecur[26]<=PS2_DATA;
                        37:codecur[27]<=PS2_DATA;
                        38:codecur[28]<=PS2_DATA;
                        39:codecur[29]<=PS2_DATA;
                        40:codecur[30]<=PS2_DATA;
                        41:codecur[31]<=PS2_DATA;
                        42:begin 
                            flag<=1'b1;
                            if(codecur!=codeprev) begin
                                mousecode[63:32]<=mousecode[31:0];
                                mousecode[31:0]<=codecur;
                                codeprev<=codecur;
                                readyflag[0]<=1'b1;
                            end
                        end
                        43:flag<=1'b0;
                    endcase
                    if(cnt<=42) cnt<=cnt+1;
                    else if(cnt==43) cnt<=0;
                end
                /*else begin//没有滚轮
                     case(cnt)
                        0:readyflag[0]<=1'b0;
                        1:codecur[0]<=PS2_DATA;
                        2:codecur[1]<=PS2_DATA;
                        3:codecur[2]<=PS2_DATA;
                        4:codecur[3]<=PS2_DATA;
                        5:codecur[4]<=PS2_DATA;
                        6:codecur[5]<=PS2_DATA;
                        7:codecur[6]<=PS2_DATA;
                        8:codecur[7]<=PS2_DATA;
                        9:flag<=1'b1;
                        10:flag<=1'b0;//第一帧结束
                        11:readyflag[1]<=1'b0;
                        12:codecur[8]<=PS2_DATA;
                        13:codecur[9]<=PS2_DATA;
                        14:codecur[10]<=PS2_DATA;
                        15:codecur[11]<=PS2_DATA;
                        16:codecur[12]<=PS2_DATA;
                        17:codecur[13]<=PS2_DATA;
                        18:codecur[14]<=PS2_DATA;
                        19:codecur[15]<=PS2_DATA;
                        20:flag<=1'b1;
                        21:flag<=1'b0;//第二帧结束
                        22:readyflag[2]<=1'b0;
                        23:codecur[16]<=PS2_DATA;
                        24:codecur[17]<=PS2_DATA;
                        25:codecur[18]<=PS2_DATA;
                        26:codecur[19]<=PS2_DATA;
                        27:codecur[20]<=PS2_DATA;
                        28:codecur[21]<=PS2_DATA;
                        29:codecur[22]<=PS2_DATA;
                        30:codecur[23]<=PS2_DATA;
                        31:begin
                            flag<=1'b1;
                            if(codecur!=codeprev) begin
                                mousecode[63:32]<=mousecode[31:0];
                                mousecode[31:0]<=codecur;
                                codeprev<=codecur;
                                readyflag[0]<=1'b1;
                            end
                        end
                        32:flag<=1'b0;
                    endcase
                    if(cnt<=31) cnt<=cnt+1;
                    else if(cnt==32) cnt<=0;
                end
            end
        end
    end*/
    //显示模块
    seg_decode seg_6(.in(mousecode[15:12]),.out(connection[4]));
    seg_decode seg_5(.in(mousecode[11:8]),.out(connection[3]));
    seg_decode seg_3(.in(mousecode[23:20]),.out(connection[2]));
    seg_decode seg_2(.in(mousecode[19:16]),.out(connection[1]));
    seg_decode seg_0(.in(mousecode[27:24]),.out(connection[0]));
    always @(posedge CLK100MHZ) begin
    counter<=counter+1;
        case (counter)
            6000: begin
                anout<=8'b01111111;
                if(mousecode[4]==1'b1)begin
                    segsout<=7'b0111111;
                end
                else begin
                    segsout<=7'b1111111;
                end
            end
            12000: begin
                anout<=8'b10111111;
                segsout<=connection[4];
            end
            18000: begin
                anout<=8'b11011111;
                segsout<=connection[3];
            end
            24000: begin
                anout<=8'b11101111;
                if(mousecode[5]==1'b1)begin
                    segsout<=7'b0111111;
                end
                else begin
                    segsout<=7'b1111111;
                end
            end
            30000: begin
                anout<=8'b11110111;
                segsout<=connection[2];
            end
            36000: begin
                anout<=8'b11111011;
                segsout<=connection[1];
            end
            42000: begin
                anout<=8'b11111101;
                if(mousecode[27]==1'b1)begin
                    segsout<=7'b0111111;
                end
                else begin
                    segsout<=7'b1111111;
                end
            end
            48000: begin
                anout<=8'b11111110;
                segsout<=connection[0];
                counter<=0;
            end
        endcase
    end
endmodule
