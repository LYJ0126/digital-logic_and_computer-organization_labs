`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2023 04:28:01 PM
// Design Name: 
// Module Name: Keyboard
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


module Keyboard(
    input clk,clrn,ps2_clk,ps2_data,
    output read_en,
    output [7:0] asciikey
);
    wire ready;
    wire overflow;
    //wire read_en;
    wire nextdata_n;
    wire [7:0] keydata;
    wire [7:0] curkey;
    //wire [7:0] asciikey;
    wire CapsLock;
    wire Shift;
    wire Ctrl;

    ps2_keyboard mykeyboard(clk ,clrn ,ps2_clk ,ps2_data ,keydata ,ready ,nextdata_n ,overflow);
    scancode_ram myscanner(clk, curkey, asciikey, CapsLock ^ Shift,Shift);
    process_scancode myprocessor(clk,clrn,ready,keydata,nextdata_n,curkey,Ctrl,Shift,CapsLock,read_en);



endmodule

module ps2_keyboard(clk,clrn,ps2_clk,ps2_data,data,ready,nextdata_n,overflow);
    input clk,clrn,ps2_clk,ps2_data;
    input nextdata_n;
    output [7:0] data;
    output reg ready;
    output reg overflow; // fifo overflow  
    // internal signal, for test
    reg [9:0] buffer; // ps2_data bits
    reg [7:0] fifo[7:0]; // data fifo
    reg [2:0] w_ptr,r_ptr; // fifo write and read pointers	
    reg [3:0] count; // count ps2_data bits
    // detect falling edge of ps2_clk
    reg [2:0] ps2_clk_sync;

    always @(posedge clk) begin
        ps2_clk_sync <=  {ps2_clk_sync[1:0],ps2_clk};
    end

    wire sampling = ps2_clk_sync[2] & ~ps2_clk_sync[1];

    always @(posedge clk) begin
        if (clrn == 0) begin // reset 
            count <= 0; w_ptr <= 0; r_ptr <= 0; overflow <= 0; ready<= 0;
        end
        else if (sampling) begin
            if (count == 4'd10) begin
                if ((buffer[0] == 0) && // start bit
                (ps2_data)       && // stop bit
                (^buffer[9:1])) begin // odd  parity
                    fifo[w_ptr] <= buffer[8:1]; // kbd scan code
                    w_ptr <= w_ptr+3'b1;
                    ready <= 1'b1;
                    overflow <= overflow | (r_ptr == (w_ptr + 3'b1));
                end
                count <= 0; // for next
            end else begin
                buffer[count] <= ps2_data; // store ps2_data 
                count <= count + 3'b1;
            end
        end
        if ( ready ) begin // read to output next data
            if(nextdata_n == 1'b0) //read next data
            begin
                r_ptr <= r_ptr + 3'b1;
                if(w_ptr==(r_ptr+1'b1)) //empty
                    ready <= 1'b0;
            end
        end
    end

    assign data = fifo[r_ptr];
endmodule

module scancode_ram(clk, addr,outdata,Caps,Shift);
    input clk;
    input [7:0] addr;
    input Caps;
    input Shift;
    output reg [7:0] outdata;
    reg [7:0] ascii_tab[255:0];
    initial
    begin
        $readmemh("F:/testOS/testOS/HardwareCode/ascii_table.txt",ascii_tab,0,255);
    end
    always @(posedge clk)
    begin
        if(Caps && ascii_tab[addr] <=122 && ascii_tab[addr]>=97)
            outdata<= ascii_tab[addr]-32;
        else if(Shift)
            begin
                case(addr)
                    8'h0e:outdata <= 8'd126;
                    8'h16:outdata <= 8'd33;
                    8'h1e:outdata <= 8'd64;
                    8'h26:outdata <= 8'd35;
                    8'h25:outdata <= 8'd36;
                    8'h2e:outdata <= 8'd37;
                    8'h36:outdata <= 8'd94;
                    8'h3d:outdata <= 8'd38;
                    8'h3e:outdata <= 8'd42;
                    8'h45:outdata <= 8'd41;
                    8'h46:outdata <= 8'd40;
                    8'h54:outdata <= 8'd123;
                    8'h5B:outdata <= 8'd124;
                    8'h4c:outdata <= 8'd58;
                    8'h52:outdata <= 8'd34;
                    8'h41:outdata <= 8'd60;
                    8'h49:outdata <= 8'd62;
                    8'h4a:outdata <= 8'd63;
                    8'h5d:outdata <= 8'd124;
                    8'h4e:outdata <= 8'd95;
                    8'h55:outdata <= 8'd43;
                    default : outdata <=32'd0;
                endcase
            end
        else
            outdata <= ascii_tab[addr];
    end

endmodule
module process_scancode(
    input clk,
    input clrn,
    input ready,
    input [7:0] keydata,

    output reg nextdata_n,
    output reg [7:0] cur_key,
    output reg Ctrl,
    output reg Shift,
    output reg CapsLock,
    output reg read_en
);
    reg CapsLock_flag;
    reg up = 0;
    reg direct;
    always@(posedge clk)
    if(!clrn)
        begin
            direct<=0;
            CapsLock_flag <=0;
            up <= 0;
            CapsLock <= 0;
            Shift <= 0;
            Ctrl <= 0;
            read_en <= 0;
        end
    else
        begin
            //if(ready &nextdata_n ) //�?始读入数�?=
            if(ready ) //�?始读入数�?=
            begin
                read_en <= 1; 
                nextdata_n<=0;
                if(up)
                    begin
                        up<=0;
                        if(keydata == 8'h58)
                            begin
                                if(CapsLock_flag)
                                    begin
                                        CapsLock_flag <= 0;
                                        CapsLock <= 0;
                                    end
                                else
                                    CapsLock_flag <= 1;
                            end
                        else if(keydata == 8'h12| keydata == 8'h59)
                            Shift <= 0;
                        else if(keydata == 8'h14)
                            Ctrl <= 0;
                    end
                else if(keydata == 8'hF0)
                begin 
                    up <= 1;
                    end
                else
                    begin 
                        if(keydata == 8'h58)
                            CapsLock <= 1;
                        else if(keydata == 8'h12 | keydata == 8'h59)
                            Shift <=  1;
                        else if(keydata == 8'h14)
                            Ctrl <= 1;
                        else
                            begin
                                read_en <= 1;
                                cur_key <= keydata;
                            end
                    end
            end
            else
                read_en <=0;
        end
        

endmodule