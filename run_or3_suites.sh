#!/bin/bash
# run_or3_suites.sh
#
# Generates branch-outcome coverage evidence for OR3 (A || B || C).
# pattern = 4*A + 2*B + C
#
# Canonical classes (OR):
#   K1: A=1              -> 4,5,6,7
#   K2: A=0,B=1          -> 2,3
#   K3: A=0,B=0,C=1      -> 1
#   K0: A=0,B=0,C=0      -> 0
#
# Suites:
#   NO_K0    : 1 2 3 4 5 6 7
#   NO_K1    : 0 1 2 3
#   NO_K2    : 0 1 4 5 6 7
#   NO_K3    : 0 2 3 4 5 6 7
#   CANONICAL: 4 2 1 0

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

SRC="or_chair/source/or3.c"
GCOV_DIR="."
BASE="reports/or3"

mkdir -p "$BASE"

run_suite() {
    local suite="$1"
    local patterns="$2"

    local SUITEDIR="$BASE/$suite"
    mkdir -p "$SUITEDIR"

    echo "========================================"
    echo "or3 - Suite $suite (patterns: $patterns)"
    echo "Output: $SUITEDIR"
    echo "========================================"

    rm -f or3.gcda or3.c.gcov

    for p in $patterns; do
        ./or3 "$p" >/dev/null || true
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

    if [ -f "or3.c.gcov" ]; then
        mv or3.c.gcov "$SUITEDIR/or3.c.gcov"
    fi

    cat "$SUITEDIR/summary.txt"
    echo
}

run_suite "NO_K0" "1 2 3 4 5 6 7"
run_suite "NO_K1" "0 1 2 3"
run_suite "NO_K2" "0 1 4 5 6 7"
run_suite "NO_K3" "0 2 3 4 5 6 7"
run_suite "CANONICAL" "4 2 1 0"