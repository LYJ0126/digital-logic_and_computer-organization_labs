#include "io.h"
#include "sys.h"

static int kbd_idx = 0;

char getch(char *addr)
{
    while (*(char *)kbd_empty)
        print_cursor();
    char ret = *((char *)kbd_start);
    if (ret == '\r')
        ret = '\n';
    putch(ret);
    *addr = ret;
    return ret;
}

char getche()
{
    while (*(char *)kbd_empty)
    {
        ;
    }
    char ret = *((char *)kbd_start);
    if (ret == '\r')
        ret = '\n';
    return ret;
}

char getche_()
{
    char ret;
    if(*(char *)kbd_empty){
        ret='!';
    }
    else{
        ret = *((char *)kbd_start);
        if (ret == '\r')
            ret = '\n';
    }
    return ret;
}