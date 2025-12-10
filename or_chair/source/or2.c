// or2.c - Homogeneous OR-only chain with 2 clauses: A || B

#include <stdio.h>
#include <stdlib.h>

/*
 * pattern = 2-bit integer: pattern = 2*A + B
 * A is bit 1, B is bit 0.
 *
 * Examples:
 *  pattern 0 -> A=0,B=0
 *  pattern 1 -> A=0,B=1
 *  pattern 2 -> A=1,B=0
 *  pattern 3 -> A=1,B=1
 *
 * Canonical classes for OR with 2 clauses:
 *  Determining value is 1, non-determining is 0.
 *  K1: A = 1               -> patterns 2,3
 *  K2: A = 0, B = 1        -> pattern 1
 *  K0: A = 0, B = 0        -> pattern 0
 */

static int pattern;

int A(void) { return (pattern >> 1) & 1; }
int B(void) { return (pattern >> 0) & 1; }

int decision(void) {
    int a = A();
    int b = B();
    if (a || b) {
        return 1;
    }
    return 0;
}

int main(int argc, char **argv) {
    pattern = atoi(argv[1]);
    int res = decision();
    printf("or2: pattern=%d -> E=%d\n", pattern, res);
    return res;
}