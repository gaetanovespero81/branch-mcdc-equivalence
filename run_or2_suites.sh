#!/bin/bash
# run_or2_suites.sh
#
# Generates branch-outcome coverage evidence for OR2 (A || B).
# pattern = 2*A + B
#
# Canonical classes (OR):
#   K1: A=1        -> 2,3
#   K2: A=0,B=1    -> 1
#   K0: A=0,B=0    -> 0
#
# Suites:
#   NO_K0    : 1 2 3
#   NO_K1    : 0 1
#   NO_K2    : 0 2 3
#   CANONICAL: 2 1 0

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

SRC="or_chair/source/or2.c"
GCOV_DIR="."
BASE="reports/or2"

mkdir -p "$BASE"

run_suite() {
    local suite="$1"
    local patterns="$2"

    local SUITEDIR="$BASE/$suite"
    mkdir -p "$SUITEDIR"

    echo "========================================"
    echo "or2 - Suite $suite (patterns: $patterns)"
    echo "Output: $SUITEDIR"
    echo "========================================"

    rm -f or2.gcda or2.c.gcov

    for p in $patterns; do
        ./or2 "$p" >/dev/null || true
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

    if [ -f "or2.c.gcov" ]; then
        mv or2.c.gcov "$SUITEDIR/or2.c.gcov"
    fi

    cat "$SUITEDIR/summary.txt"
    echo
}

run_suite "NO_K0" "1 2 3"
run_suite "NO_K1" "0 1"
run_suite "NO_K2" "0 2 3"
run_suite "CANONICAL" "2 1 0"