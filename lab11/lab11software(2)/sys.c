#include "sys.h"

extern char hello[];

char* vga_start = (char*)VGA_START;
int   vga_line = 0;//表示当前光标所在的行数
int   vga_ch = 0;
int		now_line = 0;//表示一个指令语句占用的行数

//extern int gamemain();
extern void main_1a2b();
void newline() {
	if (vga_line >= VGA_MAXLINE) {
		for (int i = 1; i < VGA_MAXLINE - 1; i++) {
			for (int j = 0; j < VGA_MAXCOL; j++) {
				vga_start[(i << 7) + j] = vga_start[((i + 1) << 7) + j];
			}
		}
		for (int j = 0; j < VGA_MAXCOL; j++)
			vga_start[((VGA_MAXLINE - 1) << 7) + j] = 0;
		vga_line = VGA_MAXLINE - 1;
	}
}

unsigned int __mulsi3(unsigned int a, unsigned int b);
int atoi(int line, int ch) {
	int ans = 0;
	while (vga_start[(line << 7) + ch] == ' ') {
		ch++;
		if (ch == VGA_MAXCOL) {
			ch = 0;
			line++;
		}
	}
	int minus = 0;
	int nonumber = 1;
	if (vga_start[(line << 7) + ch] == '-') {
		minus = 1;
		ch++;
		if (ch == VGA_MAXCOL) {
			ch = 0;
			line++;
		}
	}
	while (vga_start[(line << 7) + ch] <= '9' && vga_start[(line << 7) + ch] >= '0') {
		nonumber = 0;
		ans = __mulsi3(ans, 10);
		ans += vga_start[(line << 7) + ch] - '0';
		ch++;
		if (ch == VGA_MAXCOL) {
			ch = 0;
			line++;
		}
	}
	if (nonumber) {
		return -1;
	}
	if (minus)
		return -ans;
	return ans;
}

unsigned int fibonacci(int n) {
	if (n == 1 || n == 2) return 1;
	unsigned int f0 = 1;
	unsigned int f1 = 1;
	unsigned int f2 = 2;
	for (int i = 3; i < n; i++) {
		f0 = f1;
		f1 = f2;
		f2 = f0 + f1;
	}
	return f2;
}
unsigned int __umodsi3(unsigned int a, unsigned int b);
unsigned int __udivsi3(unsigned int a, unsigned int b);

void putint(int n) {
	char temp[32];
	int idx = 0;
	int minus = 0;
	if (n < 0) {
		minus = 1;
		n = -n;
	}
	char str[32];
	if (n == 0) {
		str[0] = '0'; str[1] = '\0';
		putstr(str);
		return;
	}
	while (n) {
		temp[idx++] = __umodsi3(n, 10) + '0';
		n = __udivsi3(n, 10);
	}
	if (minus) {
		temp[idx++] = '-';
	}
	str[idx--] = '\0';
	for (int i = 0; idx >= 0; idx--, i++)
		str[idx] = temp[i];
	putstr(str);
}


void quicksort(int l, int r);
char sort_error[] = "The number of data is too large. The limit is 32.";
int arr[32];
void sort(int line) {
	int idx = 0;
	int ch = 5;
	while (1) {
		if (idx >= 32) {
			putstr(sort_error);
			return;
		}
		arr[idx++] = atoi(line, ch);
		while (vga_start[(line << 7) + ch] == ' ') {
			ch++;
			if (ch == VGA_MAXCOL) {
				ch = 0;
				line++;
			}
		}
		if (vga_start[(line << 7) + ch] == '-') {
			ch++;
			if (ch == VGA_MAXCOL) {
				ch = 0;
				line++;
			}
		}
		while (vga_start[(line << 7) + ch] <= '9' && vga_start[(line << 7) + ch] >= '0') {
			ch++;
			if (ch == VGA_MAXCOL) {
				ch = 0;
				line++;
			}
		}
		if (vga_start[(line << 7) + ch] != ' ') break;
	}

	quicksort(0, idx - 1);
	vga_line += now_line + 1;
	vga_ch = 0;
	for (int i = 0; i < idx; i++) {
		putint(arr[i]);
		putch(' ');
	}
	putch('\n');
}
int partition(int l, int r) {
	int tmp;
	int x = arr[r];
	int i = l - 1;
	for (int j = l; j < r; j++) {
		if (arr[j] <= x) {
			i++;
			tmp = arr[i];
			arr[i] = arr[j];
			arr[j] = tmp;
		}
	}
	tmp = arr[i + 1];
	arr[i + 1] = arr[r];
	arr[r] = tmp;
	return i + 1;
}
void quicksort(int l, int r) {
	if (l < r) {
		int q = partition(l, r);
		quicksort(l, q - 1);
		quicksort(q + 1, r);
	}
}


char name[] = "--------Terminal----------------------------221220126------Luo Yuanjing----------------";
void vga_init() {
	vga_line = 1;
	vga_ch = 1;
	for (int i = 0; i < VGA_MAXLINE; i++)
		for (int j = 0; j < VGA_MAXCOL; j++)
			vga_start[(i << 7) + j] = 0;//' '
	for (int i = 0; i < VGA_MAXCOL; i++)
		vga_start[i] = name[i];
	vga_start[(1 << 7)] = '>';
	vga_start[(1 << 7) + 1] = '_';
}

void putch(char ch) {
	if (ch == 8) //backspace
	{
		//TODO
		if (now_line > 0) {
			if (vga_ch > 0) {
				vga_start[(vga_line << 7) + vga_ch] = 0;//为' '，直接删除
				vga_ch--;//光标左移
				vga_start[(vga_line << 7) + vga_ch] = 0x5f;
			}
			else {
				now_line--;//转上一行
				vga_start[(vga_line << 7) + vga_ch] = 0;//这一行的'>'删除
				vga_line--;//光标上移
				vga_ch = 79;//光标移到最后一列
				vga_start[(vga_line << 7) + vga_ch] = 0x5f;//光标显示
			}
		}
		else {
			if (vga_ch > 1) {//第一行的第一个字符不能删除
				vga_start[(vga_line << 7) + vga_ch] = 0;
				vga_ch--;
				vga_start[(vga_line << 7) + vga_ch] = 0x5f;
			}
		}

		return;
	}
	if (ch == 10 || ch == 13) //enter
	{
		//TODO
		if (now_line == 0) {
			if (vga_ch == 6) {
				if (vga_start[(vga_line << 7) + 1] == 'h') {
					if (vga_start[(vga_line << 7) + 2] == 'e' &&
						vga_start[(vga_line << 7) + 3] == 'l' &&
						vga_start[(vga_line << 7) + 4] == 'l' &&
						vga_start[(vga_line << 7) + 5] == 'o') {
						vga_start[(vga_line << 7) + vga_ch] = 0;
						vga_line++;
						if (vga_line >= VGA_MAXLINE) {
							newline();
						}
						vga_ch = 0;
						putstr(hello);
						return;
					}
				}
				else if (vga_start[(vga_line << 7) + 1] == 'c') {
					if (vga_start[(vga_line << 7) + 2] == 'l' &&
						vga_start[(vga_line << 7) + 3] == 'e' &&
						vga_start[(vga_line << 7) + 4] == 'a' &&
						vga_start[(vga_line << 7) + 5] == 'r'
						) {//清屏
						for (int i = 1; i < VGA_MAXLINE; i++) {
							for (int j = 0; j < VGA_MAXCOL; j++) {
								vga_start[(i << 7) + j] = 0;
							}
						}
						vga_line = 1; vga_ch = 1; vga_start[(1 << 7)] = '>'; vga_start[(1 << 7) + 1] = '_';
						now_line = 0;
						return;
					}
				}

			}
			if (vga_start[(vga_line << 7) + 1] == 'f'
				&& vga_start[(vga_line << 7) + 2] == 'i'
				&& vga_start[(vga_line << 7) + 3] == 'b'
				&& vga_start[(vga_line << 7) + 4] == ' ') {
				int n = atoi(vga_line, 4);

				//if(n == -1){
					//vga_start[(vga_line<<7) + vga_ch] = 0;
					//vga_line++;
					//newline();
					//vga_start[(vga_line<<7)] = '>';
					//vga_ch = 1;
					//vga_start[(vga_line<<7) + vga_ch] = '_';
					//return;
				//}
				unsigned int fib = fibonacci(n);
				vga_start[(vga_line << 7) + vga_ch] = 0;
				vga_line++;
				newline();
				vga_ch = 0;
				putint(fib);
				putch('\n');
				return;
			}
			/*if (vga_start[(vga_line << 7) + 1] == 'g' &&
				vga_start[(vga_line << 7) + 2] == 'a' &&
				vga_start[(vga_line << 7) + 3] == 'm' &&
				vga_start[(vga_line << 7) + 4] == 'e') {
				//启动游戏
				//先清屏
				for (int i = 1; i < VGA_MAXLINE; ++i) {
					for (int j = 0; j < VGA_MAXCOL; ++j) {
						vga_start[(i << 7) + j] = 0;
					}
				}
				vga_line = 0; vga_ch = 0;
				now_line = 0;
				gamemain();//游戏主函数
				vga_init();//回到命令行
			}*/
			if (vga_start[(vga_line << 7) + 1] == '1' &&
				vga_start[(vga_line << 7) + 2] == 'a' &&
				vga_start[(vga_line << 7) + 3] == '2' &&
				vga_start[(vga_line << 7) + 4] == 'b') {
				//1a2b游戏
				main_1a2b();
				vga_init();
			}
		}
		if (vga_start[((vga_line - now_line) << 7) + 1] == 's' &&
			vga_start[((vga_line - now_line) << 7) + 2] == 'o' &&
			vga_start[((vga_line - now_line) << 7) + 3] == 'r' &&
			vga_start[((vga_line - now_line) << 7) + 4] == 't' &&
			vga_start[((vga_line - now_line) << 7) + 5] == ' ') {
			vga_start[(vga_line << 7) + vga_ch] = '_';
			sort(vga_line - now_line);
			return;
		}
		vga_start[(vga_line << 7) + vga_ch] = 0;
		vga_line++;
		newline();
		vga_ch = 1;
		vga_start[(vga_line << 7)] = '>';
		vga_start[(vga_line << 7) + vga_ch] = '_';
		now_line = 0;
		return;
	}
	vga_start[(vga_line << 7) + vga_ch] = ch;//写入字符
	vga_ch++;//光标右移
	if (vga_ch >= VGA_MAXCOL)//如果光标过了最后一列
	{
		//TODO
		vga_line++;//光标下移
		if (vga_line >= VGA_MAXLINE) {//如果光标过了最后一行
			for (int i = 1; i < VGA_MAXLINE - 1; i++) {
				for (int j = 0; j < VGA_MAXCOL; j++) {
					vga_start[(i << 7) + j] = vga_start[((i + 1) << 7) + j];
				}
			}
			for (int j = 0; j < VGA_MAXCOL; j++)
				vga_start[((VGA_MAXLINE - 1) << 7) + j] = 0;
			vga_line = VGA_MAXLINE - 1;
		}
		vga_ch = 0;//光标移到最左边
		now_line++;//指令语句占用的行数+1
	}
	vga_start[(vga_line << 7) + vga_ch] = 0x5f;//光标显示'_'
	return;
}

void putstr(char* str) {
	for (char* p = str; *p != 0; p++)
		putch(*p);
}




// keyboard



int* key_head = (int*)KEY_HEAD;
int* key_tail = (int*)KEY_TAIL;
int* key_start = (int*)KEY_START;


int poll_event() {
	if (*key_head == *key_tail)
		return -1;
	int ret = key_start[*key_head];
	*key_head = __umodsi3(*key_head + 1, BUFFERSIZE);
	return ret;
}