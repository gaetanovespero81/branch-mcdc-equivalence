// or4.c - Homogeneous OR-only chain with 4 clauses: A || B || C || D

#include <stdio.h>
#include <stdlib.h>

/*
 * pattern = 4-bit integer: pattern = 8*A + 4*B + 2*C + D
 * A is bit 3, B is bit 2, C is bit 1, D is bit 0.
 *
 * Canonical classes for OR with 4 clauses:
 *  Determining value is 1, non-determining is 0.
 *
 *  K1: A = 1                           -> patterns 8..15
 *  K2: A = 0, B = 1                    -> patterns 4..7
 *  K3: A = 0, B = 0, C = 1             -> patterns 2,3
 *  K4: A = 0, B = 0, C = 0, D = 1      -> pattern 1
 *  K0: A = 0, B = 0, C = 0, D = 0      -> pattern 0
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
    if (a || b || c || d) {
        return 1;
    }
    return 0;
}

int main(int argc, char **argv) {
    pattern = atoi(argv[1]);
    int res = decision();
    printf("or4: pattern=%d -> E=%d\n", pattern, res);
    return res;
}