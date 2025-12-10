// or3.c - Homogeneous OR-only chain with 3 clauses: A || B || C

#include <stdio.h>
#include <stdlib.h>

/*
 * pattern = 3-bit integer: pattern = 4*A + 2*B + C
 * A is bit 2, B is bit 1, C is bit 0.
 *
 * Canonical classes for OR with 3 clauses:
 *  Determining value is 1, non-determining is 0.
 *
 *  K1: A = 1                        -> patterns 4,5,6,7
 *  K2: A = 0, B = 1                 -> patterns 2,3
 *  K3: A = 0, B = 0, C = 1          -> pattern 1
 *  K0: A = 0, B = 0, C = 0          -> pattern 0
 */

static int pattern;

int A(void) { return (pattern >> 2) & 1; }
int B(void) { return (pattern >> 1) & 1; }
int C(void) { return (pattern >> 0) & 1; }

int decision(void) {
    int a = A();
    int b = B();
    int c = C();
    if (a || b || c) {
        return 1;
    }
    return 0;
}

int main(int argc, char **argv) {
    pattern = atoi(argv[1]);
    int res = decision();
    printf("or3: pattern=%d -> E=%d\n", pattern, res);
    return res;
}