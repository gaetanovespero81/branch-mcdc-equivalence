#!/bin/bash
set -e

# build.sh - Compile all AND/OR chain programs with GCC coverage flags.
# Coverage data (.gcno / .gcda) will be generated in the current directory.

CFLAGS="-O0 -fprofile-arcs -ftest-coverage"

# Clean old coverage artefacts
find . -name '*.gcda' -o -name '*.gcno' -delete

# AND chains
gcc $CFLAGS and_chair/source/and2.c -o and2
gcc $CFLAGS and_chair/source/and3.c -o and3
gcc $CFLAGS and_chair/source/and4.c -o and4

# OR chains
gcc $CFLAGS or_chair/source/or2.c -o or2
gcc $CFLAGS or_chair/source/or3.c -o or3
gcc $CFLAGS or_chair/source/or4.c -o or4

echo "Build completed."