#include "sys.h"

extern char* vga_start;
extern int   vga_line;
extern int   vga_ch;
extern int		now_line;

extern unsigned int __mulsi3(unsigned int a, unsigned int b);
extern unsigned int __umodsi3(unsigned int a, unsigned int b);
extern unsigned int __udivsi3(unsigned int a, unsigned int b);

unsigned int nxt = 3;
int rand() {
	nxt = __mulsi3(nxt, (unsigned int)42) + (unsigned int)103;
	return (int)(__umodsi3(nxt, (unsigned int)10001));
}

int min(int a, int b) {
	return (a < b) ? a : b;
}

int randint(int l, int r) {//伪随机数
	//return l + (rand() & 0x7fffffff) % (r - l + 1);
	return l + (int)__umodsi3((rand() & 0x7fffffff), (unsigned int)(r - l + 1));
}

void main_1a2b()
{
	//开始前先清屏
	for(int i = 0; i < VGA_MAXLINE; i++) {
		for (int j = 0; j < VGA_MAXCOL; j++) {
			vga_start[(i << 7) + j] = 0;
		}
	}
	vga_line = 0;
	vga_ch = 0;
	now_line = 0;
	putstr((char*)"start 1a2b game");
	vga_line++;
	putstr((char*)"The computer will generate a 4-digit number, and you need to guess it.");
	vga_line++;
	int a = 1, b = 1, c = 1, d = 1, x;
	while (!(a != b && a != c && a != d && b != c && b != d && c != d)) {
		x = randint(1000, 9999);
		a = (int)__udivsi3((unsigned int)x, 1000);
		//x %= 1000;
		x = (int)__umodsi3((unsigned int)x, 1000);
		//b = x / 100;
		b = (int)__udivsi3((unsigned int)x, 100);
		//x %= 100;
		x = (int)__umodsi3((unsigned int)x, 100);
		//c = x / 10;
		c = (int)__udivsi3((unsigned int)x, 10);
		//x %= 10;
		x = (int)__umodsi3((unsigned int)x, 10);
		d = x;
	}
	//x = a * 1000 + b * 100 + c * 10 + d;
	x = __mulsi3(a, 1000) + __mulsi3(b, 100) + __mulsi3(c, 10) + d;
	int t = x, s = x, i = 4;
	int num[10];
	while (t != 0) {
		//num[i] = t % 10;
		num[i] = (int)__umodsi3((unsigned int)t, 10);
		//t /= 10;
		t = (int)__udivsi3((unsigned int)t, 10);
		i--;
	}
	int n = 0, step = 1;
	while (n != s) {
		//ss.colorprint("请猜数,结束请输入\"-1\"\n\n", 6);
		//cin >> n;
		int tempa = poll_event();
		if (tempa == 113) return;//q
		putch((char)tempa);
		int tempb = poll_event();
		putch((char)tempb);
		int tempc = poll_event();
		putch((char)tempc);
		int tempd = poll_event();
		putch((char)tempd);
		int enter = poll_event();
		if (enter == 10 || enter == 13) {
			if (a > '9' || a < '0' || b>'9' || b < '0' || c>'9' || c < '0' || d>'9' || d < '0') {
				putstr((char*)"wrong input");
				vga_line++;
				continue;
			}
			n = __mulsi3((unsigned int)(a - '0'), 1000) + __mulsi3((unsigned int)(b - '0'), 100) + __mulsi3((unsigned int)(c - '0'), 10) + (unsigned int)(d - '0');
			//if (n == -1)  return;
			/*if (n < 1000 || n>9999) {
				ss.colorprint("输入错误，请重新输入\n\n", 4);
				continue;
			}*/
			if (n < 1000 || n>9999) {
				putstr((char*)"wrong input");
				vga_line++;
				continue;
			}
			int number[5];
			int f = n, k = 4;
			/*while (f != 0) {
				number[k] = f % 10;
				f /= 10;
				k--;
			}*/
			while (f != 0) {
				number[k] = (int)__umodsi3((unsigned int)f, 10);
				f = (int)__udivsi3((unsigned int)f, 10);
				k--;
			}
			int booka[5], bookb[10];
			//memset(booka, 0, sizeof(booka));
			//memset(bookb, 0, sizeof(bookb));
			for (int i = 0; i < 5; i++) booka[i] = 0;
			for (int i = 0; i < 10; i++) bookb[i] = 0;
			int as = 0, bs = 0;//as表示数字和位置都对的个数，bs表示数字对但位置不对的个数
			for (int j = 1; j <= 4; j++) {
				if (number[j] == num[j]) {//数字和位置都对
					as++;
					booka[j] = 1;
				}
			}
			for (int j = 1; j <= 4; j++) {
				if (booka[j] == 1) continue;
				else {
					bookb[num[j]] = 1;//标记数字出现过
				}
			}
			for (int j = 1; j <= 4; j++) {
				if (booka[j] == 1) continue;//数字和位置都对的不用管
				else {
					if (bookb[number[j]] == 1) {//数字出现过，但位置不对
						bs++;
					}
				}
			}
			/*cout << "第";
			ss.colorprint(step, 12);
			cout << "步" << endl;*/
			putstr((char*)"step:");
			if (step < 10) {
				putch(' ');
				putch((char)(step + '0'));
			}
			else {
				putch((char)(__udivsi3((unsigned int)step, 10) + '0'));
				putch((char)(__umodsi3((unsigned int)step, 10) + '0'));
			}
			putch(' ');
			putch((char)(as + '0'));
			putch('A');
			putch((bs + '0'));
			putch('B');
			vga_line++;
			if (as == 4) {
				if (step <= 7) { putstr((char*)"you are genius"); vga_line++; }
				else if (step <= 10) { putstr((char*)"you are smart"); vga_line++; }
				putstr((char*)"you win");
			}
			/*if (as && bs) {
				ss.colorprint("猜对", 6), ss.colorprint(as, 3), ss.colorprint("个数字且其位置正确；", 6);
				ss.colorprint("猜对", 6), ss.colorprint(bs, 3), ss.colorprint("个数字但其位置不正确。", 6);
			}
			else if (as && bs == 0) {
				ss.colorprint("猜对", 6), ss.colorprint(as, 3), ss.colorprint("个数字且其位置正确。", 6);
			}
			else if (bs && as == 0) {
				ss.colorprint("猜对", 6), ss.colorprint(bs, 3), ss.colorprint("个数字但其位置不正确。", 6);
			}
			else ss.colorprint("没有数字猜对。", 6);
			cout << "   ";
			ss.colorprint("( ", 14), ss.colorprint(as, 12), ss.colorprint("A", 11);
			ss.colorprint(bs, 12), ss.colorprint("B", 9), ss.colorprint(" )", 14);
			cout << endl << endl;
			step++;
		}
		cout << "您猜对了" << endl;
		int fenshu = 0;
		if (step <= 5) fenshu = 100;
		else if (step > 5 && step <= 19) fenshu = 100 - 5 * (step - 5);
		else fenshu = 20;
		ss.colorprint("得分: ", 6), ss.colorprint(fenshu, 12);
		if (step <= 7) {
			cout << "Newbility!(牛逼)";
		}*/
		}
	}
	return;
}
