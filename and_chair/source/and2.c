// and2.c - Homogeneous AND-only chain with 2 clauses: A && B
// This file is intentionally minimal: the only conditional branch
// is the short-circuit decision we want to study.

#include <stdio.h>
#include <stdlib.h>

/*
 * pattern = 2-bit integer: pattern = 2*A + B
 * A is bit 1, B is bit 0.
 *
 * Examples:
 *  pattern 0 -> A=0, B=0
 *  pattern 1 -> A=0, B=1
 *  pattern 2 -> A=1, B=0
 *  pattern 3 -> A=1, B=1
 *
 * Canonical classes for AND with 2 clauses:
 *  K1: A = 0          -> patterns 0,1
 *  K2: A = 1, B = 0   -> pattern 2
 *  K0: A = 1, B = 1   -> pattern 3
 */

static int pattern;

int A(void) { return (pattern >> 1) & 1; }
int B(void) { return (pattern >> 0) & 1; }

int decision(void) {
    int a = A();
    int b = B();
    if (a && b) {
        return 1;
    }
    return 0;
}

int main(int argc, char **argv) {
    // For the experiments we always pass a valid pattern (0..3),
    // so we intentionally omit any argument checking to avoid
    // introducing extra branches.
    pattern = atoi(argv[1]);

    int res = decision();
    printf("and2: pattern=%d -> E=%d\n", pattern, res);
    return res;
}