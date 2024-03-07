#include "func.h"
#include "calculator.h"

static char hello_str[] = "Hello world!\n";
static char enter_num[] = "Enter a positive number:";
static char ans_str[] = "Ans = ";
static char enter_infix[] = "Enter an infix expression without space:\n";

static int atoi(char *str)
{
    int result = 0;
    int sign = 0;
    // proc whitespace characters
    while (*str == ' ' || *str == '\t' || *str == '\n')
        ++str;

    // proc sign character
    if (*str == '-')
    {
        sign = 1;
        ++str;
    }
    else if (*str == '+')
    {
        ++str;
    }

    // proc numbers
    while (*str >= '0' && *str <= '9')
    {
        result = result * 10 + *str - '0';
        ++str;
    }

    // return result
    if (sign == 1)
        return -result;
    else
        return result;
}

void hello()
{
    putstr(hello_str, 0xff);
}

void fib()
{
    putstr(enter_num, 0xfff);

    char tmp_str[16], ch;
    int lenth = 0;
    while (1)
    {
        char ch = getch(tmp_str + lenth);
        if (ch == 8 && lenth > 0)
        {
            lenth--;
            continue;
        }
        if (ch == '\n')
        {
            tmp_str[lenth] = '\0';
            break;
        }
        lenth++;
    }

    int n = atoi(tmp_str);

    if (n == 1 || n == 2)
        putch('1');

    n = n - 2;
    int x = 1, y = 1, tmp;
    while (n--)
    {
        tmp = x;
        x = y;
        y = tmp + y;
    }
    putstr(ans_str, 0xfff);
    putnum(y);
    putch('\n');
}

static char hour[] = "hour(s) ";
static char minute[] = "minute(s) ";
static char second[] = "second(s) ";

void time()
{
    int time = get_time();
    time = div(time, 1000);

    int min, sec, hou;

    sec = mod(time, 60);
    time = div(time, 60);

    min = mod(time, 60);
    time = div(time, 60);

    hou = mod(time, 60);

    putnum(hou);
    putch(' ');
    putstr(hour, 0xfff);
    putch(' ');
    putnum(min);
    putch(' ');
    putstr(minute, 0xfff);
    putch(' ');
    putnum(sec);
    putch(' ');
    putstr(second, 0xfff);

    putch('\n');
    return;
}

void clear()
{
    vga_clear();
}

void cal()
{
    putstr(enter_infix, 0xfff);

    char tmp_str[1024], ch;
    int lenth = 0;
    while (1)
    {
        char ch = getch(tmp_str + lenth);
        if (ch == 8)
        {
            if (lenth > 0)
            {
                lenth--;
            }
            continue;
        }
        if (ch == '\n')
        {
            tmp_str[lenth] = '\0';
            break;
        }
        lenth++;
    }

    cal_main(tmp_str);
}

int arr[64];

void realsort(int *a, int num)
{
    for (int i = 0; i < num; i++)
    {
        for (int j = i + 1; j < num; j++)
        {
            if (a[j] < a[i])
            {
                int temp = a[j];
                a[j] = a[i];
                a[i] = temp;
            }
        }
    }
}


void sort()
{
    char tembuf[128];
    int length = 0;
    while (1)
    {
        char ch = getch(tembuf + length);
        if (ch == 8)
        {
            if (length > 0)
            {
                length--;
                continue;
            }
        }
        if (ch == '\n')
        {
            tembuf[length] = '\0';
            break;
        }
        length++;
    }
    int flag = 0;
    int num = 0;
    for(int i=0;i<=64;i++) arr[i]=0;
    for (int i = 0; i <= length; i++)
    {
        if (tembuf[i] >= '0' && tembuf[i] <= '9')
        {
            arr[num] = arr[num] * 10 + (int)(tembuf[i] - '0');
            flag = 1;
        }
        else
        {
            if (flag == 1)
            {
                num++;
            }
            flag = 0;
        }
    }
    realsort(arr, num);
    for (int i = 0; i < num; i++)
    {
        putnum(arr[i]);
        putch(' ');
    }
    putch('\n');
}



void help()
{
    putstr("===================COMMAND HELP=======================\n", 0x00f);
    putstr("help     : print COMMAND HELP\n", 0x00f);
    putstr("hello    : print hello\n", 0x00f);
    putstr("time     : print time\n", 0x00f);
    putstr("fib n    : calculate fib(n)\n", 0x00f);
    putstr("cal expr : calculate expression\n", 0x00f);
    putstr("clear    : clear the screen\n", 0x00f);
    putstr("sort     : sort the numbers\n",0x00f);
    putstr("g2048    : play the game 2048\n", 0x00f);
    putstr("snake    : play the game snake\n", 0x00f);
    putstr("======================================================\n", 0x00f);
}

int score = 0;
int k = 0;
int seed = 0;

void srand()
{
    seed = 41;
}

int rand(){
    seed = ((seed * 214013 + 2531011) >> 16) & 0x7fff + get_time();
    if (seed == 41)
        seed = 40;
    return seed;
}


int get_pos_2048(int x,int y){
    return (x-1)*4+y-1;
}
/*
  1 2 3 4
1 1 1 1 1
2 1 1 1 1
3 1 1 1 1
4 1 1 1 1
*/
void g2048(){
    int map[16];//记录每个位置的数字
    score = 0;//分数
    k = 0;
    srand();//
    for (int i = 0; i <= 15; i++){//初始化清零
        map[i] = 0;
    }
    int game = 1;//game代表状态：1正在进行0结束
    char c='0';
    const char *wall[4] = {"\n----- ----- ----- -----\n", "|", "|", "|"};//场景
    int randnum=mod(rand(),15);
    map[randnum]=2;
    char last='0';
    while(1){
        c=getche();
        if(c=='q'){
            vga_clear();
            return;
        }
        else{
            if(game==1){
                if(c=='a' || c=='w' || c=='s' || c=='d'){
                    if(c=='a'){
                        for(int x=1;x<=4;x++){
                            for(int y=2;y<=4;y++){
                                int yy=y-1;
                                while(yy>1 && map[get_pos_2048(x,yy)]==0) yy--;//yy到达边界或上一个有数字的块，此时yy=1或该位置有数字
                                if(map[get_pos_2048(x,yy)]==0){//到达边界且没有数字
                                    map[get_pos_2048(x,yy)]=map[get_pos_2048(x,y)];
                                    map[get_pos_2048(x,y)]=0;
                                }
                                if(map[get_pos_2048(x,yy)]==map[get_pos_2048(x,y)]){
                                    map[get_pos_2048(x,yy)]+=map[get_pos_2048(x,y)];
                                    score+=map[get_pos_2048(x,y)];
                                    map[get_pos_2048(x,y)]=0;
                                }
                                if(map[get_pos_2048(x,yy)]!=map[get_pos_2048(x,y)]){
                                    map[get_pos_2048(x,yy+1)]=map[get_pos_2048(x,y)];
                                    if(yy+1!=y)
                                        map[get_pos_2048(x,y)]=0;
                                }
                            }
                        }   
                    }
                    if(c=='w'){
                        for(int y=1;y<=4;y++){
                            for(int x=2;x<=4;x++){
                                int xx=x-1;
                                while(xx>1 && map[get_pos_2048(xx,y)]==0) xx--;//xx到达边界或上一个有数字的块，此时xx=1或该位置有数字
                                if(map[get_pos_2048(xx,y)]==0){//到达边界且没有数字
                                    map[get_pos_2048(xx,y)]=map[get_pos_2048(x,y)];
                                    map[get_pos_2048(x,y)]=0;
                                }
                                if(map[get_pos_2048(xx,y)]==map[get_pos_2048(x,y)]){
                                    map[get_pos_2048(xx,y)]+=map[get_pos_2048(x,y)];
                                    score+=map[get_pos_2048(x,y)];
                                    map[get_pos_2048(x,y)]=0;
                                }
                                if(map[get_pos_2048(xx,y)]!=map[get_pos_2048(x,y)]){
                                    map[get_pos_2048(xx+1,y)]=map[get_pos_2048(x,y)];
                                    if(xx+1!=x)
                                        map[get_pos_2048(x,y)]=0;
                                }
                            }
                        }
                    }
                    if(c=='s'){
                        for(int y=1;y<=4;y++){
                            for(int x=3;x>=1;x--){
                                int xx=x+1;
                                while(xx<4 && map[get_pos_2048(xx,y)]==0) xx++;//xx到达边界或上一个有数字的块，此时xx=1或该位置有数字
                                if(map[get_pos_2048(xx,y)]==0){//到达边界且没有数字
                                    map[get_pos_2048(xx,y)]=map[get_pos_2048(x,y)];
                                    map[get_pos_2048(x,y)]=0;
                                }
                                if(map[get_pos_2048(xx,y)]==map[get_pos_2048(x,y)]){
                                    map[get_pos_2048(xx,y)]+=map[get_pos_2048(x,y)];
                                    score+=map[get_pos_2048(x,y)];
                                    map[get_pos_2048(x,y)]=0;
                                    }
                                if(map[get_pos_2048(xx,y)]!=map[get_pos_2048(x,y)]){
                                    map[get_pos_2048(xx-1,y)]=map[get_pos_2048(x,y)];
                                    if(xx-1!=x)
                                        map[get_pos_2048(x,y)]=0;
                                }
                            }
                        }
                    }
                    if(c=='d'){
                        for(int x=1;x<=4;x++){
                            for(int y=3;y>=1;y--){
                                int yy=y+1;
                                while(yy<4 && map[get_pos_2048(x,yy)]==0) yy++;//yy到达边界或上一个有数字的块，此时yy=1或该位置有数字
                                if(map[get_pos_2048(x,yy)]==0){//到达边界且没有数字
                                    map[get_pos_2048(x,yy)]=map[get_pos_2048(x,y)];
                                    map[get_pos_2048(x,y)]=0;
                                }
                                if(map[get_pos_2048(x,yy)]==map[get_pos_2048(x,y)]){
                                    map[get_pos_2048(x,yy)]+=map[get_pos_2048(x,y)];
                                    score+=map[get_pos_2048(x,y)];
                                    map[get_pos_2048(x,y)]=0;
                                }
                                if(map[get_pos_2048(x,yy)]!=map[get_pos_2048(x,y)]){
                                    map[get_pos_2048(x,yy-1)]=map[get_pos_2048(x,y)];
                                    if(yy-1!=y)
                                        map[get_pos_2048(x,y)]=0;
                                }
                            }
                        }   
                    }
                    //生成新数字
                    randnum=mod(rand(),16);
                    while(map[randnum]!=0){
                        randnum++;
                        if(randnum==16) randnum=0;
                    }
                    int pos=randnum;
                    int val=mod(rand(),3);
                    if(val<=1) val=2;
                    else val=4;
                    map[pos]=val;
                }
                vga_clear();
                int game=0;
                for(int i=0;i<16;i++)
                    if(map[i]==0) game=1;
                if (game==0){
                    char x[] = "Game over! Press q to quit.(Cai jiu duo lian)";
                    putstr(x, 0xfff);
                    //break;
                }
                else{
                    char x[] = "score: ";
                    putstr(x, 0xfff);
                    putnum(score);
                }
                for (int i = 0; i < 16; i++){
                    if(i==0||i==4||i==8||i==12){
                        char x[]="\n----- ----- ----- -----\n";
                        putstr(x,0xfff);
                    }
                    char x1[] = "    ";
                    char x2[] = "   ";
                    char x3[] = "  ";
                    char x4[] = " ";
                    char x5[] = "";
                    if (map[i] > 10000)
                        putstr(x5, 0xfff);
                    else if (map[i] > 1000)
                        putstr(x4, 0xfff);
                    else if (map[i] > 100)
                        putstr(x3, 0xfff);
                    else if (map[i] > 10)
                        putstr(x2, 0xff0);
                    else if (map[i] >= 0)
                        putstr(x1, 0x0ff);
                    putnum(map[i]);
                    putstr("|",0xfff);
                }
            }
                
        }
            
    }
}


void sleep(){
    int t = get_time();
    int c = get_time();
    while (t + 100 >= c)
        c = get_time();
    return;
}

#define WIDTH 60
#define HEIGHT 26
#define SIZE WIDTH*HEIGHT
int map_[SIZE];

int direction;//0:right(d);1:up(w);2:down(s);3:left(a)
int len;
int next_x[SIZE];
int next_y[SIZE];
int pos_x[SIZE];
int pos_y[SIZE];
int fruit_x;
int fruit_y;
int is_eat;
int flag_gameover;
int get_pos_snake(int x,int y){
    return (x-1)*WIDTH+y-1;
}
void Draw(){
	//printf("Score: %d;tail: %d,%d\n",len-5,pos_x[len],pos_y[len]);
    putstr("Score: ",0xfff);
    putnum(len-5);
    putch('\n');
	for(int i=1;i<=WIDTH+2;i++) putch('#');
	putch('\n');
	for(int i=1;i<=HEIGHT;i++){
		putch('#');
		for(int j=1;j<=WIDTH;j++){
			if(map_[get_pos_snake(i,j)]==1) putch('*');
			if(map_[get_pos_snake(i,j)]==2) putch('@');
			if(map_[get_pos_snake(i,j)]==0) putch(' ');
		}
		putstr("#\n",0xfff);
	}
	for(int i=1;i<=WIDTH+2;i++) putch('#');
	putch('\n');
}
int get_fruit(){
	fruit_x=mod(rand(),HEIGHT)+1;
	fruit_y=mod(rand(),WIDTH)+1;
    int position=get_pos_snake(fruit_x,fruit_y);
	while(map_[get_pos_snake(fruit_x,fruit_y)]==1){
		position++;
        if(position==SIZE) position=0;
	}
	return position;
}
int game;//0:loading;1:playing;2:gameover;
void init_snake(){
	srand();
	for(int i=0;i<SIZE;i++){
		map_[i]=0;
		next_x[i]=0;
		next_y[i]=0;
		pos_x[i]=0;
		pos_y[i]=0;
	} 
    flag_gameover=0;
    game=0;
	direction=0;
	len=5;
	pos_x[1]=1;pos_y[1]=5;
	pos_x[2]=1;pos_y[2]=4;next_x[2]=1;next_y[2]=5;
	pos_x[3]=1;pos_y[3]=3;next_x[3]=1;next_y[3]=4;
	pos_x[4]=1;pos_y[4]=2;next_x[4]=1;next_y[4]=3;
	pos_x[5]=1;pos_y[5]=1;next_x[5]=1;next_y[5]=2;
	map_[0]=1;
	map_[1]=1;
	map_[2]=1;
	map_[3]=1;
	map_[4]=1;
	map_[get_fruit()]=2;
	is_eat=0;
}


void snake(){
    char ch;
    init_snake();
    vga_clear();
    Draw();
    putstr("Press any key to start\n",0xfff);
    int cnt=0;
    while(1){
        ch=getche_();
        if(ch=='q'){
            vga_clear();
            return;
        } 
        if(game==0){
            if (ch!='!'){
                game=1;
			}
		}
		else{
			if(game==2){
                if(flag_gameover=0){
                    //system("cls");
                    vga_clear();
                    putstr("game over. Caijiuduolian shubuqijiubiewan ",0xfff);
                    Draw();
                    flag_gameover=1;
                }
                //break;
			}
			else{
				cnt++;
				if(cnt==10000){
					cnt=0;
					//system("cls");
					vga_clear();
					//0:right(d);1:up(w);2:down(s);3:left(a)
					if(direction==0){
						next_y[1]=pos_y[1]+1;
						next_x[1]=pos_x[1];	
					} 
					if(direction==1){
						next_y[1]=pos_y[1];
						next_x[1]=pos_x[1]-1;	
					}
					if(direction==2){
						next_y[1]=pos_y[1];
						next_x[1]=pos_x[1]+1;	
					}
					if(direction==3){
						next_y[1]=pos_y[1]-1;
						next_x[1]=pos_x[1];	
					}
					if(map_[get_pos_snake(next_x[1],next_y[1])]==1 || next_x[1]>HEIGHT || next_x[1]<1 || next_y[1]>WIDTH || next_y[1]<1){
						game=2;
					}
					if(map_[get_pos_snake(next_x[1],next_y[1])]==2){
						is_eat=1;
					}
					map_[get_pos_snake(next_x[1],next_y[1])]=1;
					if(is_eat==1){
						pos_x[len+1]=pos_x[len];
						pos_y[len+1]=pos_y[len];
						next_x[len+1]=next_x[len];
						next_y[len+1]=next_y[len];
					}
					else{
						map_[get_pos_snake(pos_x[len],pos_y[len])]=0;
					}
					for(int i=1;i<=len;i++){
						pos_x[i]=next_x[i];
						pos_y[i]=next_y[i];
					}
					for(int i=2;i<=len;i++){
						next_x[i]=pos_x[i-1];
						next_y[i]=pos_y[i-1];
					}
					if(is_eat==1){
						len++;
						is_eat=0;
                        map_[get_fruit()]=2;
					}
					Draw();
				} 
				if(ch=='a'&& direction!=0) direction=3;
				if(ch=='s'&& direction!=1) direction=2;
				if(ch=='w'&& direction!=2) direction=1;
				if(ch=='d'&& direction!=3) direction=0;
                }
			}
		}
		
	}


