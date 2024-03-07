`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/30 20:04:39
// Design Name: 
// Module Name: Mode_X
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


module Mode_X(
    input  wire pix_clk,
    input  wire[11:0] pix_x,
    input  wire[11:0] pix_y,
    input  wire pix_valid,
    input  wire[7:0] ascii,
    input  wire[7:0] cnt,
    output wire[11:0] pix_data,
    output wire[2:0] mode
    );
    parameter totlen = 256;

reg [7:0] display[29:0][79:0]; //stores the info being displayed
reg [6:0] cur_x;              //cursor/current x
reg [4:0] cur_y;              //cursor/current y
reg [63:0] cur_cnt;           //counts the light/dim time of cursor
reg cur_state;                //cursor is light or dim

reg [7:0] strbuf[255:0];
reg [7:0] strlen;

reg [2:0] mode_x;//same as mode, need a better name :(
assign mode = mode_x;
reg [7:0] pre_cnt;
reg [7:0] flag;

reg [3:0] msg_out;

//The following registers are for calculator

reg cal_working;
reg [2:0] s[totlen - 1:0]; //000:+  001:-  010:*  011:/  100:(  101:)
reg [31:0] l_val[totlen - 1:0];
reg [2:0] l_type[totlen - 1:0]; //000:+  001:-  010:*  011:/  111:NUMBER
reg [7:0] sp, lp, bp;
reg [7:0] l_len;
reg [2:0] state;
reg [31:0] temp;
wire [7:0] cha;
assign cha = strbuf[bp];
//convert
reg match_state;//0 idle 1 num
reg [2:0] prec; //000:+  001:-  010:*  011:/  100:(  101:)
//calculate
reg [31:0] ss[totlen - 1:0];
reg [7:0] ssp;
reg [1:0] caltype;
reg rst;
reg in_valid;
wire [31:0] add_res, div_res, div_rem;
wire [63:0] mul_res;
wire mul_valid, div_valid, div_error;
reg [31:0] calx, caly;
wire OF, SF, ZF, CF, cout;
Adder32 Adder32_inst(.f(add_res), .OF(OF), .SF(SF), .ZF(ZF), .CF(CF), .cout(cout), .x(calx), .y(caly), .sub(caltype[0]));
mul_32b mul_32b_inst(.clk(pix_clk),.rst_n(rst),.x(calx),.y(caly),.in_valid(in_valid),.p(mul_res),.out_valid(mul_valid));
//mul_32u mul_32u_inst(.clk(pix_clk), .rst(rst), .x(calx), .y(caly), .in_valid(in_valid), .p(mul_res), .out_valid(mul_valid));
div_32b div_32b_inst(.Q(div_res), .R(div_rem), .out_valid(div_valid), .in_error(div_error), .clk(pix_clk), .rst(rst), .X(calx), .Y(caly), .in_valid(in_valid));
//result
reg [31:0] result;
reg [3:0] outcnt, outcntt;
reg [7:0] calout[9:0];

integer i, j;

reg [8*80-1:0] str[8:0];

initial begin
    str[0] = "-------Xterminal---------------------------221220126-Luo Yuanjing-20231031------";//80
    str[1] = "[G]raphics";//10
    str[2] = "[I]mage";//7
    str[3] = "[T]xt";//5
    str[4] = "[C]alculator";//12
    str[5] = "Main>";//5
    str[6] = "Calculator>";//11
    str[7] = "Divided by zero";//15
    str[8] = "Invalid expression";//18
    for (i = 0; i < 30; i = i + 1) begin
        for (j = 0; j < 80; j = j + 1) begin
            display[i][j] = 0;
        end
    end
    
    for (i = 0; i < 80; i = i + 1) display[0][i] = str[0][i * 8 +: 8];
    for (i = 0; i < 10; i = i + 1) display[1][i + 70] = str[1][i * 8 +: 8];
    for (i = 0; i < 7; i = i + 1) display[2][i + 73] = str[2][i * 8 +: 8];
    for (i = 0; i < 5; i = i + 1) display[3][i + 75] = str[3][i * 8 +: 8];
    for (i = 0; i < 12; i = i + 1) display[4][i + 68] = str[4][i * 8 +: 8];
    for (i = 0; i < 5; i = i + 1) display[6][i + 75] = str[5][i * 8 +: 8];
    
    cur_x = 5;
    cur_y = 6;
    
    for (i = 0; i < 256; i = i + 1) strbuf[i] = 0;
    strlen = 0;
    
    cal_working = 0;
    sp = 0;
    lp = 0;
    bp = 0;
    l_len = 0;
    state = 0;
    temp = 0;
    match_state = 0;
    prec = 0;
    ssp = 0;
    result = 0;
    in_valid = 0;
    outcnt = 0;
    outcntt = 0;
    rst = 0;
    
    cur_cnt = 0;
    cur_state = 0;
    
    mode_x = 0;
end

parameter return_asc = 8'h0d;
parameter backspace_asc = 8'h08;

wire [6:0] inp_x;
wire [4:0] inp_y;
wire [6:0] del_x;
wire [4:0] del_y;
assign inp_x = 80 - 1 - cur_x;
assign inp_y = cur_y;
assign del_x = cur_x == 0 ? 0 : 80 - cur_x;
assign del_y = cur_x == 0 ? cur_y - 1 : cur_y;

always @(posedge pix_clk) begin
    if (cal_working) begin
        case (state)
            3'b000: begin
                if (bp != strlen) begin
                    if (cha >= 48 && cha <= 57) begin
                        temp <= 10 * temp + cha - 48;
                        bp <= bp + 1;
                        match_state <= 1;
                        if (10 * temp + cha - 48 > 32'hffffffff) begin
                            state <= 3'b111;
                        end
                    end
                    else if (match_state) begin
                        l_val[lp] <= temp;
                        temp <= 0;
                        l_type[lp] <= 3'b111;
                        lp <= lp + 1;
                        match_state <= 0;
                    end
                    if (cha == "+" || cha == "-" || cha == "*" || cha == "/") begin
                        if (cha == "+") prec <= 3'b000;
                        if (cha == "-") prec <= 3'b001;
                        if (cha == "*") prec <= 3'b010;
                        if (cha == "/") prec <= 3'b011;
                        state <= 3'b001;
                    end
                    if (cha == "(") begin
                        s[sp] <= 3'b100;
                        sp <= sp + 1;
                        bp <= bp + 1;
                    end
                    if (cha == ")") begin
                        state <= 3'b010;
                    end
                    if (cha == " ") begin
                        bp <= bp + 1;
                    end
                end
                else if (match_state) begin
                    l_val[lp] <= temp;
                    temp <= 0;
                    l_type[lp] <= 3'b111;
                    lp <= lp + 1;
                    match_state <= 0;
                end
                else if (sp) begin
                    if (s[sp - 1] == 3'b100) begin
                        state <= 3'b111;
                    end
                    else begin
                        l_type[lp] <= s[sp - 1];
                        lp <= lp + 1;
                        sp <= sp - 1;
                    end
                end
                else begin
                    l_len <= lp;
                    lp <= 0;
                    state <= 3'b011;
                end
            end
            3'b001: begin
                if (prec == 3'b000 || prec == 3'b001) begin
                    if (sp == 0 || s[sp - 1] == 3'b100) begin
                        s[sp] <= prec;
                        sp <= sp + 1;
                        bp <= bp + 1;
                        state <= 3'b000;
                    end
                    else begin
                        l_type[lp] <= s[sp - 1];
                        lp <= lp + 1;
                        sp <= sp - 1;
                    end
                end
                else if (prec == 3'b010 || prec == 3'b011) begin
                    if (sp == 0 || s[sp - 1] == 3'b000 || s[sp - 1] == 3'b001 || s[sp - 1] == 3'b100) begin
                        s[sp] <= prec;
                        sp <= sp + 1;
                        bp <= bp + 1;
                        state <= 3'b000;
                    end
                    else begin
                        l_type[lp] <= s[sp - 1];
                        lp <= lp + 1;
                        sp <= sp - 1;
                    end
                end
            end
            3'b010: begin
                if (sp == 0) begin
                    state <= 3'b111;
                end
                else if (s[sp - 1] == 3'b100) begin
                    sp <= sp - 1;
                    bp <= bp + 1;
                    state <= 3'b000;
                end
                else begin
                    l_type[lp] <= s[sp - 1];
                    lp <= lp + 1;
                    sp <= sp - 1;
                end
            end
            3'b011: begin
                if (lp != l_len) begin
                    lp <= lp + 1;
                    if (l_type[lp][2] == 0) begin
                        if (ssp == 0 || ssp == 1) begin
                            state <= 3'b111;
                        end
                        else begin
                            state <= 3'b100;
                            calx <= ss[ssp - 2];
                            caly <= ss[ssp - 1];
                            caltype <= l_type[lp][1:0];
                            if (l_type[lp][1]) begin
                                in_valid <= 1;
                            end
                        end
                    end
                    else begin
                        ss[ssp] <= l_val[lp];
                        ssp <= ssp + 1;
                    end
                end
                else if (ssp == 1) begin
                    result <= ss[0];
                    temp <= ss[0];
                    outcnt <= 0;
                    outcntt <= 0;
                    cur_x <= 0;
                    cur_y <= cur_y + 1;
                    state <= 3'b101;
                end
                else begin
                    state <= 3'b111;
                end
            end
            3'b100: begin
                case (caltype)
                    2'b00: begin
                        ss[ssp - 2] <= add_res;
                        ssp <= ssp - 1;
                        state <= 3'b011;
                    end
                    2'b01: begin
                        ss[ssp - 2] <= add_res;
                        ssp <= ssp - 1;
                        state <= 3'b011;
                    end
                    2'b10: begin
                        if (in_valid) begin
                            in_valid <= 0;
                        end
                        else if (mul_valid) begin
                            ss[ssp - 2] <= mul_res[31:0];
                            ssp <= ssp - 1;
                            state <= 3'b011;
                        end
                    end
                    2'b11: begin
                        if (in_valid) begin
                            in_valid <= 0;
                        end
                        else if (div_valid) begin
                            ss[ssp - 2] <= div_res;
                            ssp <= ssp - 1;
                            state <= 3'b011;
                        end
                        else if (div_error) begin
                            if (caly) begin
                                ss[ssp - 2] <= 0;
                                ssp <= ssp - 1;
                                state <= 3'b011;
                            end
                            else begin
                                state <= 3'b110;
                            end
                        end
                    end
                    
                endcase
            end
            3'b101: begin
                if (temp) begin
                    calout[outcnt] <= temp % 10 + 48;
                    temp <= temp / 10;
                    outcnt <= outcnt + 1;
                end
                else if (outcnt != outcntt) begin
                    display[cur_y][80 - outcntt - 1] <= calout[outcnt - outcntt - 1];
                    outcntt <= outcntt + 1;
                end
                else begin
                    if (result == 0) display[cur_y][79] <= 48;
                    cur_x <= 5;
                    cur_y <= cur_y + 1;
                    for (i = 0; i < 5; i = i + 1) display[cur_y + 1][i + 75] <= str[5][i * 8 +: 8];
                    strlen <= 0;
                    mode_x <= 0;
                    cal_working <= 0;
                end
            end
            3'b110: begin
                cur_x <= 5;
                cur_y <= cur_y + 2;
                for (i = 0; i < 15; i = i + 1) display[cur_y + 1][i + 65] = str[7][i * 8 +: 8];
                for (i = 0; i < 5; i = i + 1) display[cur_y + 2][i + 75] = str[5][i * 8 +: 8];
                strlen <= 0;
                mode_x <= 0;
                cal_working <= 0;
            end
            3'b111: begin
                cur_x <= 5;
                cur_y <= cur_y + 2;
                for (i = 0; i < 18; i = i + 1) display[cur_y + 1][i + 62] = str[8][i * 8 +: 8];
                for (i = 0; i < 5; i = i + 1) display[cur_y + 2][i + 75] = str[5][i * 8 +: 8];
                strlen <= 0;
                mode_x <= 0;
                cal_working <= 0;
            end
            default:;
        endcase
    end
    else if (pre_cnt != cnt) begin
        pre_cnt <= cnt;
        flag <= 1;
    end
    else if (flag) begin
        flag <= 0;
        if (mode_x == 0) begin
            if (ascii == return_asc) begin
                if (strbuf[0] == "C") begin
                    cur_x <= 11;
                    cur_y <= cur_y + 1;
                    for (i = 0; i < 11; i = i + 1) display[cur_y + 1][i + 69] <= str[6][i * 8 +: 8];
                    strlen <= 0;
                    for (i = 0; i < 256; i = i + 1) strbuf[i] <= 0;
                    mode_x <= 4;
                end
                else begin
                    cur_x <= 5;
                    cur_y <= cur_y + 1;
                    for (i = 0; i < 5; i = i + 1) display[cur_y + 1][i + 75] <= str[5][i * 8 +: 8];
                    strlen <= 0;
                    for (i = 0; i < 256; i = i + 1) strbuf[i] <= 0;
                    if (strbuf[0] == "G") begin
                        mode_x <= 1;
                    end
                    if (strbuf[0] == "I") begin
                        mode_x <= 2;
                    end
                    if (strbuf[0] == "T") begin
                        mode_x <= 3;
                    end
                end
            end
            if (ascii == backspace_asc) begin
                if (strlen != 0) begin
                    display[del_y][del_x] <= 0;
                    cur_x <= cur_x == 0 ? 79 : cur_x - 1;
                    cur_y <= cur_x == 0 ? cur_y - 1 : cur_y;
                    strbuf[strlen - 1] <= 0;
                    strlen <= strlen - 1;
                end
            end
            if (ascii >= 32 && ascii <= 126) begin
                display[inp_y][inp_x] <= ascii;
//                display[29][79] <= ascii;
                cur_x <= cur_x == 79 ? 0 : cur_x + 1;
                cur_y <= cur_x == 79 ? cur_y + 1 : cur_y;
                strbuf[strlen] <= ascii;
                strlen <= strlen + 1;
            end
        end
        else if (mode_x == 1 || mode_x == 2 || mode_x == 3) begin
            mode_x <= 0;
        end
        
        else begin //mode_x == 4
            if (ascii == return_asc) begin
                cal_working <= 1;
                sp <= 0;
                lp <= 0;
                bp <= 0;
                ssp <= 0;
                state <= 0;
                match_state <= 0;
            end
            if (ascii == backspace_asc) begin
                if (strlen != 0) begin
                    display[del_y][del_x] <= 0;
                    cur_x <= cur_x == 0 ? 79 : cur_x - 1;
                    cur_y <= cur_x == 0 ? cur_y - 1 : cur_y;
                    strbuf[strlen - 1] <= 0;
                    strlen <= strlen - 1;
                end
            end
            if (ascii >= 40 && ascii <= 57 && ascii != 44 && ascii != 46 || ascii == 32) begin
                display[inp_y][inp_x] <= ascii;
                cur_x <= cur_x == 79 ? 0 : cur_x + 1;
                cur_y <= cur_x == 79 ? cur_y + 1 : cur_y;
                strbuf[strlen] <= ascii;
                strlen <= strlen + 1;
            end
        end
        
    end
end

reg [6:0] pre_cur_x;
reg [4:0] pre_cur_y;

always @(posedge pix_clk) begin
    cur_cnt <= cur_cnt + 1;
    
    if (pre_cur_x != cur_x || pre_cur_y != cur_y) begin
        cur_cnt <= 0;
        cur_state <= 0;
    end else
    if (cur_cnt == 12499999) begin
        cur_cnt <= 0;
        cur_state <= ~cur_state;
    end
    pre_cur_x <= cur_x;
    pre_cur_y <= cur_y;
end

wire [6:0] cha_x;
wire [4:0] cha_y;
wire [2:0] cha_pix_x;
wire [3:0] cha_pix_y;
assign {cha_x, cha_pix_x} = pix_x[9:0];
assign {cha_y, cha_pix_y} = pix_y[8:0];

wire [7:0] cha_ascii;
assign cha_ascii = cha_x == cur_x && cha_y == cur_y ? cur_state ? 8'h20 : 8'hdd : display[cha_y][80 - 1 - cha_x];

wire [11:0] display_data;
posasc2bit posasc2bit_inst(
.cha_pix_x(cha_pix_x),
.cha_pix_y(cha_pix_y),
.pix_valid(pix_valid),
.cha_ascii(cha_ascii),
.pix_data(pix_data)
);
endmodule
