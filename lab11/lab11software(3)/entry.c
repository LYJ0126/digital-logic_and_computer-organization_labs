extern int main();

void _start()
{
    asm("lui sp, 0x00120");
    asm("addi sp, sp, -4");
    main();
}