#!/bin/bash
# run_and3_suites.sh
#
# Generates branch-outcome coverage evidence for AND3 (A && B && C).
# Suites:
#   NO_K0    : 0 1 2 3 4 5 6        (all except K0 = 7)
#   NO_K1    : 4 5 6 7              (all except K1 = 0,1,2,3)
#   NO_K2    : 0 1 2 3 6 7          (all except K2 = 4,5)
#   NO_K3    : 0 1 2 3 4 5 7        (all except K3 = 6)
#   CANONICAL: 1 4 6 7              (one per Ki)
#
# Output per suite:
#   reports/and3/<SUITE>/
#     gcov.txt
#     summary.txt
#     and3.c.gcov

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

SRC="and_chair/source/and3.c"
GCOV_DIR="."
BASE="reports/and3"

mkdir -p "$BASE"

run_suite() {
    local suite="$1"
    local patterns="$2"

    local SUITEDIR="$BASE/$suite"
    mkdir -p "$SUITEDIR"

    echo "========================================"
    echo "and3 - Suite $suite (patterns: $patterns)"
    echo "Output: $SUITEDIR"
    echo "========================================"

    rm -f and3.gcda and3.c.gcov

    for p in $patterns; do
        ./and3 "$p" >/dev/null || true
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

    if [ -f "and3.c.gcov" ]; then
        mv and3.c.gcov "$SUITEDIR/and3.c.gcov"
    fi

    cat "$SUITEDIR/summary.txt"
    echo
}

run_suite "NO_K0" "0 1 2 3 4 5 6"
run_suite "NO_K1" "4 5 6 7"
run_suite "NO_K2" "0 1 2 3 6 7"
run_suite "NO_K3" "0 1 2 3 4 5 7"
run_suite "CANONICAL" "1 4 6 7"