`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 13:48:41
// Design Name: 
// Module Name: DigitalTimer
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


module DigitalTimer(  //端口声明
  input clk,
  input rst,            //复位，有效后00:00:00
  input [1:0] s,        // =00时，进入计数；01：设置小时；10：设置分钟；11：设置秒
  input [3:0] data_h,   //设置初值高位，使用BCD码表示
  input [3:0] data_l,   //设置初值低位，使用BCD码表示
  output [6:0] segs,   //七段数码管输入值，显示数字
  output [7:0] an,     //七段数码管控制位，控制时、分、秒 
  output [2:0] ledout   //输出3色指示灯
); 
// Add your code
    wire clk2;
    //秒分时低、高位
    reg [3:0] s_l;
    reg [3:0] s_h;
    reg [3:0] m_l; 
    reg [3:0] m_h;
    reg [3:0] h_l;
    reg [3:0] h_h;
    reg [2:0] threecolor;//3色灯
    reg tcs1;//提示3色灯闪烁5s
    reg tcs2;//提示3色灯闪烁10s
    reg [15:0] counter1;//计数器，用于数码显示管刷新
    reg [3:0] counter2;//计数器，由于整点3色灯闪烁计数
    reg [3:0] counter3;//计数器，用于0点3色灯闪烁计数
    reg [6:0] segsout;//段输入
    reg [7:0] anout;//位输入
    wire [6:0] connection [5:0];//连接数码段译码以及数码管
    clkgen clock(.clkin(clk),.rst(0),.clken(1),.clkout(clk2));
    seg_decode seg_hh(.in(h_h),.out(connection[5]));
    seg_decode seg_hl(.in(h_l),.out(connection[4]));
    seg_decode seg_mh(.in(m_h),.out(connection[3]));
    seg_decode seg_ml(.in(m_l),.out(connection[2]));
    seg_decode seg_sh(.in(s_h),.out(connection[1]));
    seg_decode seg_sl(.in(s_l),.out(connection[0]));
    assign segs=segsout;
    assign an=anout;
    assign ledout=threecolor;
    always @(posedge clk2) begin
        if(rst==1'b1) begin//复位
            s_l<=0;
            s_h<=0;
            m_l<=0;
            m_h<=0;
            h_l<=0;
            h_h<=0;
            tcs1<=0;
            tcs2<=0;
            threecolor<=0;
        end
        else begin
            case (s)
            2'b01: begin
                h_h<=data_h;
                h_l<=data_l;
            end
            2'b10: begin
                m_h<=data_h;
                m_l<=data_l;
            end
            2'b11: begin
                s_h<=data_h;
                s_l<=data_l;
            end
            2'b00: begin//计数
                if(m_h==5&&m_l==9&&s_h==5&&s_l==8) begin
                    if(h_h==2&&h_l==3) begin
                        tcs2<=1;//0点闪烁准备
                    end
                    else begin
                        tcs1<=1;//整点闪烁准备
                    end
                end
                if(tcs1) begin
                    threecolor<=(1<<(counter2%3));
                    if(counter2==5) begin
                        counter2<=0;
                        tcs1<=0;
                        threecolor<=0;//记得还原
                    end
                    else begin
                        counter2<=counter2+1;
                    end
                end
                else if(tcs2) begin
                    threecolor<=(1<<(counter3%3));
                    if(counter3==10) begin
                        counter3<=0;
                        tcs2<=0;
                        threecolor<=0;//记得还原
                    end
                    else begin
                        counter3<=counter3+1;
                    end
                end
                if(s_l<9) s_l<=s_l+1;
                else if(s_l==9&&s_h<5) begin
                    s_l<=0;
                    s_h<=s_h+1;
                end
                else begin
                    if(s_h==5&&m_l<9) begin
                        s_l<=0;
                        s_h<=0;
                        m_l<=m_l+1;
                    end
                    else if(m_l==9&&m_h<5)begin
                        s_l<=0;
                        s_h<=0;
                        m_l<=0;
                        m_h<=m_h+1;
                    end
                    else begin
                        if((m_h==5&&h_h<2&&h_l<9)||(m_h==5&&h_h==2&&h_l<3))begin
                            s_l<=0;
                            s_h<=0;
                            m_l<=0;
                            m_h<=0;
                            h_l<=h_l+1;
                        end
                        else begin
                            if(h_l==9&&h_h<2) begin
                                s_l<=0;
                                s_h<=0;
                                m_l<=0;
                                m_h<=0;
                                h_l<=0;
                                h_h<=h_h+1;
                            end
                            else if(h_h==2&&h_l==3) begin
                                s_l<=0;
                                s_h<=0;
                                m_l<=0;
                                m_h<=0;
                                h_l<=0;
                                h_h<=0;
                            end
                        end
                    end
                end
            end
            endcase
        end
    end
    always @(posedge clk) begin//数码管显示，注意用原时钟
        counter1<=counter1+1;
        case (counter1)
            6000: begin
                anout<=8'b01111111;
                segsout<=connection[5];
            end
            12000: begin
                anout<=8'b10111111;
                segsout<=connection[4];
            end
            18000: begin
                anout<=8'b11011111;
                segsout<=7'b0111111;
            end
            24000: begin
                anout<=8'b11101111;
                segsout<=connection[3];
            end
            30000: begin
                anout<=8'b11110111;
                segsout<=connection[2];
            end
            36000: begin
                anout<=8'b11111011;
                segsout<=7'b0111111;
            end
            42000: begin
                anout<=8'b11111101;
                segsout<=connection[1];
            end
            48000: begin
                anout<=8'b11111110;
                segsout<=connection[0];
                counter1<=0;
            end
        endcase
    end
endmodule


