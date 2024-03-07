//#pragma once
#define VGA_START    0x00200000//分配给VGA
#define VGA_LINE_O   0x00210000
#define VGA_MAXLINE  30
#define LINE_MASK    0x003f
#define VGA_MAXCOL   80
#define KEY_START 0x00300000//分配给键盘
#define KEY_HEAD 0x003ffff0
#define KEY_TAIL 0x003fffe0
#define BUFFERSIZE 32
void putstr(char* str);
void putch(char ch);

void vga_init(void);

int poll_event(void);
