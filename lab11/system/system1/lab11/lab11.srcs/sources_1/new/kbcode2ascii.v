`timescale 1ns / 1ps

module kbcode2ascii(
      output[7:0] asciicode,
      input [7:0] kbcode
);
    reg [7:0] kb_mem[255:0];
    initial
    begin
     $readmemh("C:/Vivadolabs/lab5/lab5_pdf_and_resources/lab5/scancode.txt", kb_mem, 0, 255);  //ÐÞ¸Äscancode.txt´æ·ÅÂ·¾¶
    end
    assign   asciicode = kb_mem[kbcode];
endmodule
