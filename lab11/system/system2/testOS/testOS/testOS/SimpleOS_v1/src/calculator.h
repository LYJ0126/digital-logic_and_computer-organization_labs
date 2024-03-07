#include "sys.h"
#include "arith.h"

enum operators {
    Positive, // 值为0
    Negative, // 值为1
    Reverse,  // 值为2
    Multiply,
    Divideby,
    Module,
    Plus,
    Minus,
    Less,
    Greater,
    LeftBracket,
    RightBracket
};

void cal_main(char *expr);