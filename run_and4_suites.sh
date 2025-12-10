#!/bin/bash
# run_and4_suites.sh
#
# Generates branch-outcome coverage evidence for AND4 (A && B && C && D).
# pattern = 8*A + 4*B + 2*C + D
#
# Canonical classes (AND):
#   K1: A=0                      -> 0..7
#   K2: A=1,B=0                  -> 8,9,10,11
#   K3: A=1,B=1,C=0              -> 12,13
#   K4: A=1,B=1,C=1,D=0          -> 14
#   K0: A=1,B=1,C=1,D=1          -> 15
#
# Suites:
#   NO_K0    : 0..14
#   NO_K1    : 8 9 10 11 12 13 14 15
#   NO_K2    : 0 1 2 3 4 5 6 7 12 13 14 15
#   NO_K3    : 0 1 2 3 4 5 6 7 8 9 10 11 14 15
#   NO_K4    : 0 1 2 3 4 5 6 7 8 9 10 11 12 13 15
#   CANONICAL: 1 8 12 14 15

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

SRC="and_chair/source/and4.c"
GCOV_DIR="."
BASE="reports/and4"

mkdir -p "$BASE"

run_suite() {
    local suite="$1"
    local patterns="$2"

    local SUITEDIR="$BASE/$suite"
    mkdir -p "$SUITEDIR"

    echo "========================================"
    echo "and4 - Suite $suite (patterns: $patterns)"
    echo "Output: $SUITEDIR"
    echo "========================================"

    rm -f and4.gcda and4.c.gcov

    for p in $patterns; do
        ./and4 "$p" >/dev/null || true
    done

    local GCOV_RAW="$SUITEDIR/gcov.txt"
    gcov -b "$SRC" -o "$GCOV_DIR" > "$GCOV_RAW"

    local line_cov
    local taken_cov
    line_cov=$(grep -m1 "Lines executed:" "$GCOV_RAW" | sed 's/^ *//')
    taken_cov=$(grep -m1 "Taken at least once:" "$GCOV_RAW" | sed 's/^ *//')

    {
        echo "Suite: $suite"
        echo "Patterns: $patterns"
        echo "$line_cov"
        echo "$taken_cov"
    } > "$SUITEDIR/summary.txt"

    if [ -f "and4.c.gcov" ]; then
        mv and4.c.gcov "$SUITEDIR/and4.c.gcov"
    fi

    cat "$SUITEDIR/summary.txt"
    echo
}

run_suite "NO_K0" "0 1 2 3 4 5 6 7 8 9 10 11 12 13 14"
run_suite "NO_K1" "8 9 10 11 12 13 14 15"
run_suite "NO_K2" "0 1 2 3 4 5 6 7 12 13 14 15"
run_suite "NO_K3" "0 1 2 3 4 5 6 7 8 9 10 11 14 15"
run_suite "NO_K4" "0 1 2 3 4 5 6 7 8 9 10 11 12 13 15"
run_suite "CANONICAL" "1 8 12 14 15"