// and3.c - Homogeneous AND-only chain with 3 clauses: A && B && C

#include <stdio.h>
#include <stdlib.h>

/*
 * pattern = 3-bit integer: pattern = 4*A + 2*B + C
 * A is bit 2, B is bit 1, C is bit 0.
 *
 * Examples:
 *  pattern 0 -> A=0,B=0,C=0
 *  pattern 1 -> A=0,B=0,C=1
 *  pattern 2 -> A=0,B=1,C=0
 *  pattern 3 -> A=0,B=1,C=1
 *  pattern 4 -> A=1,B=0,C=0
 *  pattern 5 -> A=1,B=0,C=1
 *  pattern 6 -> A=1,B=1,C=0
 *  pattern 7 -> A=1,B=1,C=1
 *
 * Canonical classes for AND with 3 clauses:
 *  K1: A = 0                 -> patterns 0,1,2,3
 *  K2: A = 1, B = 0          -> patterns 4,5
 *  K3: A = 1, B = 1, C = 0   -> pattern 6
 *  K0: A = 1, B = 1, C = 1   -> pattern 7
 */

static int pattern;

int A(void) { return (pattern >> 2) & 1; }
int B(void) { return (pattern >> 1) & 1; }
int C(void) { return (pattern >> 0) & 1; }

int decision(void) {
    int a = A();
    int b = B();
    int c = C();
    if (a && b && c) {
        return 1;
    }
    return 0;
}

int main(int argc, char **argv) {
    pattern = atoi(argv[1]);
    int res = decision();
    printf("and3: pattern=%d -> E=%d\n", pattern, res);
    return res;
}