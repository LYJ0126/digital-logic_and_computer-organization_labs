#include "sys.h"


char hello[]="Hello World 2022!\n";

int main();

//setup the entry point
void entry()
{
    asm("lui sp, 0x00120"); //set stack to high address of the dmem
    asm("addi sp, sp, -4");
    main();
}

int main()
{
    vga_init();
  
    //putstr(hello);
		int ev;
    while (1)
    {
			if((ev = poll_event()) == -1) continue;
			putch((char)ev);
    };
    return 0;
}
