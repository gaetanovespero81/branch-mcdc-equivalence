#!/bin/bash
set -e

rm -rf refactor_example/original refactor_example/original.gcno refactor_example/original.gcda
rm -rf refactor_example/refactored refactor_example/refactored.gcno refactor_example/refactored.gcda

chmod +x build_refactor.sh
./build_refactor.sh

chmod +x run_refactor_suites.sh
./run_refactor_suites.sh

rm -rf refactor_example/original refactor_example/original.gcno refactor_example/original.gcda
rm -rf refactor_example/refactored refactor_example/refactored.gcno refactor_example/refactored.gcda