#!/bin/bash
# run_and2_suites.sh
#
# Generates branch-outcome coverage evidence for AND2 (A && B).
# Saves per-suite folders:
#   reports/and2/NO_K0/
#   reports/and2/NO_K1/
#   reports/and2/NO_K2/
#   reports/and2/CANONICAL/
#
# Each folder contains:
#   gcov.txt        (raw gcov -b output)
#   summary.txt     (clean summary)
#   and2.c.gcov     (annotated gcov file)

set -e

# Ensure execution from script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

SRC="and_chair/source/and2.c"
GCOV_DIR="."   # gcov data (.gcno/.gcda) are in this directory
BASE="reports/and2"

mkdir -p "$BASE"

# ------------------------------------------------------------
# Helper to execute each suite
# ------------------------------------------------------------
run_suite() {
    local suite="$1"
    local patterns="$2"

    local SUITEDIR="$BASE/$suite"
    mkdir -p "$SUITEDIR"

    echo "========================================"
    echo "and2 - Suite $suite (patterns: $patterns)"
    echo "Output: $SUITEDIR"
    echo "========================================"

    # Reset coverage
    rm -f and2.gcda and2.c.gcov

    # Execute patterns (ignore exit code because TRUE returns 1)
    for p in $patterns; do
        ./and2 "$p" >/dev/null || true
    done

    # Save full gcov output
    GCOV_RAW="$SUITEDIR/gcov.txt"
    gcov -b "$SRC" -o "$GCOV_DIR" > "$GCOV_RAW"

    # Extract coverage summary
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

    # Save annotated gcov file
    # gcov generates and2.c.gcov in current directory → move it
    if [ -f "and2.c.gcov" ]; then
        mv and2.c.gcov "$SUITEDIR/and2.c.gcov"
    fi

    # Show summary
    cat "$SUITEDIR/summary.txt"
    echo
}

# ------------------------------------------------------------
# Run all AND2 suites
# ------------------------------------------------------------
run_suite "NO_K0" "0 1 2"
run_suite "NO_K1" "2 3"
run_suite "NO_K2" "0 1 3"
run_suite "CANONICAL" "1 2 3"