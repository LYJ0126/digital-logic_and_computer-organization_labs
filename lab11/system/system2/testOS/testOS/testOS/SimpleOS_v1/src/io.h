/*---------------------vga------------------------*/
#define vga_start 0x00200000
#define start_line 0x00201fff

#define maxLine 30
#define maxCol 70

#define logo_height 6

#define addr(col, line) ((col << 6) + line)

void vga_logoDisplay();
void vga_clear();

/*---------------------timer------------------------*/
#define timer_start 0x00400000

unsigned int get_time();
void wait(unsigned int dtime);

/*---------------------kbd------------------------*/
#define kbd_start 0x00300000
#define kbd_empty 0x00300fff

#define maxBuff 32

char getch(char *addr); // change cursor while there is no input
char getche();
char getche_();