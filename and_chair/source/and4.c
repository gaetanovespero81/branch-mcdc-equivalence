// and4.c - Homogeneous AND-only chain with 4 clauses: A && B && C && D

#include <stdio.h>
#include <stdlib.h>

/*
 * pattern = 4-bit integer: pattern = 8*A + 4*B + 2*C + D
 * A is bit 3, B is bit 2, C is bit 1, D is bit 0.
 * patterns 0..15 cover all 16 combinations.
 *
 * Canonical classes for AND with 4 clauses:
 *  K1: A = 0                          -> patterns 0..7
 *  K2: A = 1, B = 0                   -> patterns 8,9,10,11
 *  K3: A = 1, B = 1, C = 0            -> patterns 12,13
 *  K4: A = 1, B = 1, C = 1, D = 0     -> pattern 14
 *  K0: A = 1, B = 1, C = 1, D = 1     -> pattern 15
 */

static int pattern;

int A(void) { return (pattern >> 3) & 1; }
int B(void) { return (pattern >> 2) & 1; }
int C(void) { return (pattern >> 1) & 1; }
int D(void) { return (pattern >> 0) & 1; }

int decision(void) {
    int a = A();
    int b = B();
    int c = C();
    int d = D();
    if (a && b && c && d) {
        return 1;
    }
    return 0;
}

int main(int argc, char **argv) {
    pattern = atoi(argv[1]);
    int res = decision();
    printf("and4: pattern=%d -> E=%d\n", pattern, res);
    return res;
}