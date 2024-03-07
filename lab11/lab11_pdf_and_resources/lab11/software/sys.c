#include "sys.h"


char* vga_start = (char*) VGA_START;
int   vga_line=0;
int   vga_ch=0;


void vga_init(){
    vga_line = 0;
    vga_ch =0;
    for(int i=0;i<VGA_MAXLINE;i++)
        for(int j=0;j<VGA_MAXCOL;j++)
            vga_start[ (i<<7)+j ] =0;
}

void putch(char ch) {
  if(ch==8) //backspace
  {
      //TODO
      return;
  }
  if(ch==10) //enter
  {
      //TODO
      return;
  }
  vga_start[ (vga_line<<7)+vga_ch] = ch;
  vga_ch++;
  if(vga_ch>=VGA_MAXCOL)
  {
     //TODO
  }
  return;
}

void putstr(char *str){
    for(char* p=str;*p!=0;p++)
      putch(*p);
}