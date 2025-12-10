#!/bin/bash
# run_or4_suites.sh
#
# Generates branch-outcome coverage evidence for OR4 (A || B || C || D).
# pattern = 8*A + 4*B + 2*C + D
#
# Canonical classes (OR):
#   K1: A=1                       -> 8..15
#   K2: A=0,B=1                   -> 4..7
#   K3: A=0,B=0,C=1               -> 2,3
#   K4: A=0,B=0,C=0,D=1           -> 1
#   K0: A=0,B=0,C=0,D=0           -> 0
#
# Suites:
#   NO_K0    : 1..15
#   NO_K1    : 0..7
#   NO_K2    : 0 1 2 3 8 9 10 11 12 13 14 15
#   NO_K3    : 0 1 4 5 6 7 8 9 10 11 12 13 14 15
#   NO_K4    : 0 2 3 4 5 6 7 8 9 10 11 12 13 14 15
#   CANONICAL: 8 4 2 1 0

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

SRC="or_chair/source/or4.c"
GCOV_DIR="."
BASE="reports/or4"

mkdir -p "$BASE"

run_suite() {
    local suite="$1"
    local patterns="$2"

    local SUITEDIR="$BASE/$suite"
    mkdir -p "$SUITEDIR"

    echo "========================================"
    echo "or4 - Suite $suite (patterns: $patterns)"
    echo "Output: $SUITEDIR"
    echo "========================================"

    rm -f or4.gcda or4.c.gcov

    for p in $patterns; do
        ./or4 "$p" >/dev/null || true
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

    if [ -f "or4.c.gcov" ]; then
        mv or4.c.gcov "$SUITEDIR/or4.c.gcov"
    fi

    cat "$SUITEDIR/summary.txt"
    echo
}

run_suite "NO_K0" "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15"
run_suite "NO_K1" "0 1 2 3 4 5 6 7"
run_suite "NO_K2" "0 1 2 3 8 9 10 11 12 13 14 15"
run_suite "NO_K3" "0 1 4 5 6 7 8 9 10 11 12 13 14 15"
run_suite "NO_K4" "0 2 3 4 5 6 7 8 9 10 11 12 13 14 15"
run_suite "CANONICAL" "8 4 2 1 0"