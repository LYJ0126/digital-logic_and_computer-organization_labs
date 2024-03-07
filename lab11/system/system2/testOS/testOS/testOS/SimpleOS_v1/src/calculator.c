#include "calculator.h"

struct stack_int
{
    int buff[256];
    int top_idx;
};

static struct stack_int opera;

static void stack_int()
{
    opera.top_idx = -1;
}

static int empty()
{
    return (opera.top_idx == -1);
}

static int top()
{
    return opera.buff[opera.top_idx];
}

static void pop()
{
    if (opera.top_idx >= 0)
        opera.top_idx--;
}

static void push(int i)
{
    if (opera.top_idx == 255)
        return;
    opera.buff[++opera.top_idx] = i;
    return;
}

static int runtime_error;

static int positive(int a, int b)
{
    return a;
}

static int negative(int a, int b)
{
    return -a;
}

static int multiply(int a, int b)
{
    return multi(a, b);
}

static int divideby(int a, int b)
{
    if (b == 0)
    {
        runtime_error = 1;
        return 0;
    }
    return div(a, b);
}

static int reverse(int a, int b)
{
    return (~a);
}

static int module(int a, int b)
{
    if (b == 0)
    {
        runtime_error = 1;
        return 0;
    }
    return mod(a, b);
}

static int plus(int a, int b)
{
    return a + b;
}

static int minus(int a, int b)
{
    return a - b;
}

static int less(int a, int b)
{
    return ((a < b) ? 1 : 0);
}

static int greater(int a, int b)
{
    return ((a > b) ? 1 : 0);
}

static int (*opt[])(int, int) = {
    [Positive] = positive,
    [Negative] = negative,
    [Reverse] = reverse,
    [Multiply] = multiply,
    [Divideby] = divideby,
    [Module] = module,
    [Plus] = plus,
    [Minus] = minus,
    [Less] = less,
    [Greater] = greater};

struct Node
{
    int flag;
    int val;
};

static struct Node postfix[20000];
;

static char *infix;

static int getid(int position)
{
    switch (infix[position])
    {
    case '+':
        if (position >= 1 && infix[position - 1] <= '9' && infix[position - 1] >= '0' ||
            infix[position - 1] == ')')
        {
            return Plus;
        }
        else
        {
            return Positive;
        }
    case '-':
        if (position >= 1 && infix[position - 1] <= '9' && infix[position - 1] >= '0' ||
            infix[position - 1] == ')')
        {
            return Minus;
        }
        else
        {
            return Negative;
        }
    case '*':
        return Multiply;
    case '/':
        return Divideby;
    case '%':
        return Module;
    case '~':
        return Reverse;
    case '<':
        return Less;
    case '>':
        return Greater;
    case '(':
        return LeftBracket;
    case ')':
        return RightBracket;
    default:
        return infix[position];
    }
}

static int associativity[256];
static int priority[256];
static int single[256];

enum
{
    LeftAssociative = 0,
    RightAssociative = 1
};

static int pn;

static void infix_to_postfix()
{
    int length = strlen(infix);
    for (int i = 0; i < length; i++)
    {
        int to_be = getid(i);
        if (to_be <= '9' && to_be >= '0')
        {
            i++;
            int temp = to_be - '0';
            while (infix[i] <= '9' && infix[i] >= '0')
            {
                temp = temp * 10 + infix[i] - '0';
                i++;
            }
            postfix[pn].flag = 1;
            postfix[pn].val = temp;
            pn++;
            i--;
        }
        else if (to_be == LeftBracket)
            push(to_be);
        else if (to_be == RightBracket)
        {
            int temp = top();
            while (temp != LeftBracket)
            {
                postfix[pn].val = temp;
                postfix[pn].flag = 0;
                pop();
                temp = top();
                pn++;
            }
            pop();
        }
        else
        {
            while ((!empty()) && (top() != LeftBracket) && (priority[top()] <= priority[to_be]) &&
                   ((priority[to_be] != priority[top()]) || (associativity[top()] != RightAssociative)))
            {
                postfix[pn].val = top();
                postfix[pn].flag = 0;
                pop();
                pn++;
            }
            push(to_be);
        }
    }
    while (!empty())
    {
        postfix[pn].val = top();
        postfix[pn].flag = 0;
        pop();
        pn++;
    }
}

static int calculate()
{
    for (int i = 0; i < pn; i++)
    {
        if (postfix[i].flag == 1)
        {
            push(postfix[i].val);
            continue;
        }
        else if (!single[postfix[i].val])
        {
            int temp1 = top();
            pop();
            int temp2 = top();
            pop();
            push(opt[postfix[i].val](temp2, temp1));
            continue;
        }
        else if (single[postfix[i].val])
        {
            int temp = opt[postfix[i].val](top(), 0);
            pop();
            push(temp);
            continue;
        }
        if (runtime_error == 1)
            return 0;
    }
    int answer = top();
    pop();
    return answer;
}

static void init()
{
    associativity[Negative] = associativity[Positive] = associativity[Reverse] = RightAssociative;
    single[Negative] = single[Positive] = single[Reverse] = 1;
    priority[LeftBracket] = priority[RightBracket] = 1;
    priority[Positive] = priority[Negative] = priority[Reverse] = 2;
    priority[Multiply] = priority[Divideby] = priority[Module] = 3;
    priority[Plus] = priority[Minus] = 4;
    priority[Greater] = priority[Less] = 5;
}

static void clear()
{
    runtime_error = 0;
    pn = 0;
}

static char re[] = "Runtime Error\n";
static char ans_STR[] = "Ans = ";

void cal_main(char *expr)
{
    clear();
    stack_int();
    infix = expr;
    infix_to_postfix();
    init();
    int t = calculate();
    if (runtime_error)
    {
        putstr(re, 0xf00);
    }
    else
    {
        putstr(ans_STR, 0x0f0);
        putnum(t);
        putch('\n');
    }
}
