#include "sys.h"
#include "arith.h"

extern unsigned cur_line, cur_col;

static int buff_num = 0;

#define ch_mask 0x000000ff
void putch(int tmp_ch) {
    char ch = tmp_ch & ch_mask;
    if (ch == 8) {
//        if (buff_num <= 10)
//            return;
//        buff_num--;
        ((char *) vga_start)[addr(cur_col, cur_line)] = 0;
        if (cur_col != 0) {
            cur_col = cur_col - 1;
            return;
        }
        if (cur_line != 0) {
            cur_line = cur_line - 1;
            cur_col = maxCol - 1;
            return;
        }
        return;
    }
    if (ch == '\n') {
//        buff_num = 0;
        ((char *) vga_start)[addr(cur_col, cur_line)] = 0;
        cur_col = 0;
        cur_line = cur_line + 1;
        if (cur_line >= maxLine)
            *(char *) start_line = (char) (cur_line - maxLine + 1);
        return;
    }
    ((char *) vga_start)[addr(cur_col, cur_line)] = tmp_ch;
    cur_col++;
//    buff_num++;
    if (cur_col > maxCol) {
        cur_col = 0;
        cur_line++;
        if (cur_line >= maxLine)
            *(char *) start_line = (char) (cur_line - maxLine + 1);
    }

    return;
}

void putstr(char *str, int color) {
    for (; *str; str++)
        putch(((int)*str) + (color << 8));
}

int strcmp(char *str1, char *str2) {
    for (; *str1 && *str2; str1++, str2++)
        if (*str1 != *str2)
            return 1;
    if (*str1 == 0 && *str2 == 0)
        return 0;
    else
        return 1;
}

unsigned strlen(char *str) {
    unsigned cnt = 0;
    while (*(str + cnt))
        cnt++;
    return cnt;
}

void putnum(int n) {
    if (n == 0) {
        putch('0');
        return;
    }

    if (n < 0)
        putch('-');

    n = (n < 0) ? -n : n;

    int tmp_num[32];
    int i = 0;
    while (n) {
        tmp_num[i++] = mod(n, 10);
        n = div(n, 10);
    }

    i = i - 1;
    for (; i >= 0; i--)
        putch(tmp_num[i] + '0');
}

static int cur_state = 0;

void print_cursor() {
    wait(500);
    if (cur_state) {
        ((char *) vga_start)[addr(cur_col, cur_line)] = '_';
        cur_state = 0;
    } else {
        ((char *) vga_start)[addr(cur_col, cur_line)] = ' ';
        cur_state = 1;
    }
}