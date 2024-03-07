#include "arith.h"

int abs(int num) {
    return num < 0 ? -num : num;
}

int multi(int a, int b) {
    int multiplier = abs(a), multiplicand = abs(b);

    int product = 0;
    while (multiplicand) {
        if (multiplicand & 0x1) {
            product = product + multiplier;
        }
        multiplier = multiplier << 1;
        multiplicand = multiplicand >> 1;
    }

    if ((a ^ b) < 0) {
        product = -product;
    }

    return product;
}

int bitlength(int a) {
    int length = 0;
    while (a) {
        length = length + 1;
        a = a >> 1;
    }
    return length;
}

int lengthdiff(int a, int b) {
    return bitlength(a) - bitlength(b);
}

int div(int a, int b) {
    int dividend = abs(a), divisor = abs(b);

    int quotient = 0;
    for (int i = lengthdiff(dividend, divisor); i >= 0; i = i - 1) {
        int r = (divisor << i);
        // Left shift divisor until it's smaller than dividend
        if (r <= dividend) {
            quotient |= (1 << i);
            dividend = dividend - r;
        }
    }

    if ((a ^ b) < 0) {
        quotient = -quotient;
    }

    return quotient;
}

int mod(int a, int b) {
    int dividend = abs(a), divisor = abs(b);

    for (int i = lengthdiff(dividend, divisor); i >= 0; i--) {
        int r = (divisor << i);
        // Left shift divisor until it's smaller than dividend
        if (r <= dividend) {
            dividend = dividend - (int) r;
        }
    }

    if (a < 0) {
        dividend = -dividend;
    }

    return dividend;
}