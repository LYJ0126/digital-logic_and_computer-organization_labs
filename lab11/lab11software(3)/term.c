#include "sys.h"
#include "func.h"
#include "io.h"

#define CMD_NUM (sizeof(cmds) / sizeof(cmds[0]))
int main();
struct handle
{
    char *name;
    void (*func)();
} cmds[] = {
    {"hello", hello},
    {"fib", fib},
    {"time", time},
    {"clear", clear},
    {"cal", cal},
    {"sort", sort},
    {"help", help},
    {"g2048", g2048},
    {"snake", snake}};

void start()
{
    asm("lui sp, 0x00120");
    asm("addi sp, sp, -4");
    main();
}
void printPrompt()
{
    putstr("User:root$", 0x00f);
}

void divide_Command(char *str)
{
    for (int i = 0; *(str + i) != '\0'; i++)
        if (*(str + i) == ' ')
        {
            *(str + i) = '\0';
            break;
        }
}

void dealCommand(char *str)
{
    for (int i = 0; i < CMD_NUM; ++i)
    {
        if (strcmp(cmds[i].name, str) == 0)
        {
            cmds[i].func();
            return;
        }
    }
    putstr("Invalid command!\n", 0xf00);
}

int main()
{
    wait(1500);
    vga_clear();
    // logo页
    vga_logoDisplay();
    // 初始化
    vga_clear();
    char str[256];
    // 主循环
    while (1)
    {
        printPrompt();
        int lenth = 0;
        while (1)
        {
            char ch = getch(str + lenth);
            if (ch == 8 && lenth > 0)
            {
                lenth--;
                continue;
            }
            if (ch == '\n')
            {                      // getch的同时会显示在屏幕上，键盘只需要将ascii码写入
                str[lenth] = '\0'; // 替换最后的换行符
                break;
            }
            lenth++;
        }
        divide_Command(str);
        dealCommand(str);
    }
}