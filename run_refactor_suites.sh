#!/bin/bash
# run_refactor_suites.sh
#
# Runs the refactoring example on:
#   - refactor_example/original.c   (executable: original)
#   - refactor_example/refactored.c (executable: refactored)
#
# Suites:
#   ALL   : T1 T2 T3
#
# For each suite we collect:
#   reports/refactor/<prog>/<suite>/gcov.txt
#   reports/refactor/<prog>/<suite>/summary.txt
#   reports/refactor/<prog>/<suite>/<src>.gcov

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REF_DIR="$SCRIPT_DIR/refactor_example"
REPORT_BASE="$SCRIPT_DIR/reports/refactor"

mkdir -p "$REPORT_BASE"

# ---------- test mapping ----------
get_args_for_test() {
    case "$1" in
        1) echo "0 1 0"   ;;  # T1 f x f -> f
        2) echo "10 1 1"  ;;  # T2 t f f -> f => Not sodisfy MC/DC masked on first clause (true)
        3) echo "10 0 0"  ;;  # T3 t t f -> f => Not sodisfy MC/DC masked on first clause (true)
        *) echo "0 0 0"   ;;
    esac
}

# ---------- execute suite ----------
run_suite_for_prog() {
    local prog="$1"          # original / refactored (exec)
    local src="$2"           # original.c / refactored.c
    local prog_label="$3"    # "original" or "refactored"
    local suite="$4"         # e.g. ALL
    local tests="$5"         # e.g. "1 2 3"

    local SUITEDIR="$REPORT_BASE/$prog_label/$suite"
    mkdir -p "$SUITEDIR"

    echo "========================================"
    echo "Program: $prog_label  Suite: $suite (tests: $tests)"
    echo "Source : $src"
    echo "Output : $SUITEDIR"
    echo "========================================"

    cd "$REF_DIR"

    # Very important: do NOT delete .gcno
    rm -f "$prog.gcda"   # reset coverage data
    rm -f "$src.gcov"    # remove previous annotated file if any

    # Execute suite
    for tid in $tests; do
        args=$(get_args_for_test "$tid")
        #./"$prog" $args >/dev/null || true
        ./"$prog" $args || true
    done

    # Run gcov -b locally (GENERATES src.gcov here)
    gcov -b "$src" > "$SUITEDIR/gcov.txt"

    # Move .gcov file into report directory (if created)
    if [ -f "$src.gcov" ]; then
        mv "$src.gcov" "$SUITEDIR/$src.gcov"
    fi

    cd "$SCRIPT_DIR"

    # Extract coverage summary from gcov.txt
    local line_cov
    local taken_cov
    line_cov=$(grep -m1 "Lines executed:" "$SUITEDIR/gcov.txt" | sed 's/^ *//')
    taken_cov=$(grep -m1 "Taken at least once:" "$SUITEDIR/gcov.txt" | sed 's/^ *//')

    {
        echo "Program: $prog_label"
        echo "Suite:   $suite"
        echo "Tests:   $tests"
        echo "$line_cov"
        echo "$taken_cov"
    } > "$SUITEDIR/summary.txt"

    # Show summary
    cat "$SUITEDIR/summary.txt"
    echo
}

# ---------- suites ----------
SUITE_ALL="1 2 3"

# ---------- run for original ----------
run_suite_for_prog "original"   "original.c"   "original"   "ALL"   "$SUITE_ALL"

# ---------- run for refactored ----------
run_suite_for_prog "refactored" "refactored.c" "refactored" "ALL"   "$SUITE_ALL"