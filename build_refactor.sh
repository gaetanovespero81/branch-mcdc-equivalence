#!/bin/bash
# build_refactor.sh
#
# Build the refactoring example programs inside refactor_example/:
#   original.c   -> original
#   refactored.c -> refactored

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/refactor_example"

CFLAGS="-O0 -fprofile-arcs -ftest-coverage"

gcc $CFLAGS original.c   -o original
gcc $CFLAGS refactored.c -o refactored

echo "Refactor example build completed in $(pwd)."